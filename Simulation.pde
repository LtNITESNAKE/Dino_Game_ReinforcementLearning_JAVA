int DINOS_PER_GENERATION = 100;   // Small focused population
float MIN_SPAWN_MILLIS = 2000;    // Like Chrome game initial spawn rate
float MAX_SPAWN_MILLIS = 3000;    // More breathing room between obstacles

class Simulation { 
  ArrayList<Dino> dinos;
  ArrayList<Enemy> enemies;  
  float speed;  // Constant speed for better learning
  Ground ground;
  int score;
  int generation;
  int last_gen_avg_score;
  int last_gen_max_score;
  int dinos_alive;
  boolean showing_transition = false;
  int transition_start_time;

  // Dynamic spawn control
  float last_spawn_time;
  float time_to_spawn;
  
  Simulation() {
    dinos = new ArrayList<Dino>();
    for (int i = 0; i < DINOS_PER_GENERATION; i++) {
      dinos.add(new Dino());    }    enemies = new ArrayList<Enemy>();    speed = 15;  // Starting speed
    ground = new Ground();
    score = 0;
    generation = 1;
    last_gen_avg_score = 0;
    last_gen_max_score = 0;
    dinos_alive = DINOS_PER_GENERATION;
    last_spawn_time = millis();
    time_to_spawn = random(MIN_SPAWN_MILLIS, MAX_SPAWN_MILLIS);
  }
  
  void update() {
    if (showing_transition) {
      return; // Don't update game state during transition
    }
    
    for (Dino dino : dinos) {
      if (dino.alive){
        dino.update(next_obstacle_info(dino), (int)speed);
      }
    }
    Iterator<Enemy> iterator = enemies.iterator();
    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();
      enemy.update((int)speed);
      if (enemy.is_offscreen()) {
        iterator.remove();
      }
    }
    if (millis() - last_spawn_time > time_to_spawn) {
      spawn_enemy();
      last_spawn_time = millis();
      time_to_spawn = random(MIN_SPAWN_MILLIS, MAX_SPAWN_MILLIS);
    }    check_collisions();    ground.update((int)speed);
  }

  void check_collisions() {
    dinos_alive = 0;
    for (Dino dino : dinos) {
      for (Enemy enemy : enemies) {
        if (dino.alive && dino.is_collisioning_with(enemy)) {
          dino.die(score);
        }
      }
      if (dino.alive) {
        dinos_alive++;
      }
    }
    if (dinos_alive == 0) {
      next_generation();
    }
  }
  void next_generation() {
    score = 0;
    generation++;
    enemies.clear();
    
    // Start transition screen
    showing_transition = true;
    transition_start_time = millis();
    
    // Calculate fitness scores
    int total_score = 0;
    float max_score = 0;
    for (Dino dino : dinos) {
      total_score += dino.score;
      max_score = max(max_score, dino.score);
    }
    last_gen_avg_score = total_score / DINOS_PER_GENERATION;
    last_gen_max_score = (int)max_score;
    
    // Sort dinos by score
    Collections.sort(dinos);
    Collections.reverse(dinos);
    
    ArrayList<Dino> new_dinos = new ArrayList<Dino>();
    
    // Elite selection - keep top 10% unchanged
    int eliteCount = (int)(DINOS_PER_GENERATION * 0.1);
    for (int i = 0; i < eliteCount; i++) {
      new_dinos.add(dinos.get(i));
      new_dinos.get(i).reset();
    }
    
    // Fresh blood - 5% new random dinos
    int newCount = (int)(DINOS_PER_GENERATION * 0.05);
    for (int i = 0; i < newCount; i++) {
      new_dinos.add(new Dino());
    }
    
    // Tournament selection for parents
    while (new_dinos.size() < DINOS_PER_GENERATION) {
      // Select parents through tournament
      Dino parent1 = tournamentSelect(3); // Tournament size of 3
      Dino parent2 = tournamentSelect(3);
      
      Dino child = new Dino();
      
      // 70% chance of crossover, otherwise clone better parent
      if (random(1) < 0.7) {
        child.genome = parent1.genome.crossover(parent2.genome);
      } else {
        child.genome = (parent1.score > parent2.score) ? 
                      parent1.genome.copy() : parent2.genome.copy();
      }
      
      // Always mutate offspring
      child.genome = child.genome.mutate();
      child.init_brain();
      new_dinos.add(child);
    }
    
    dinos = new_dinos;
    dinos_alive = DINOS_PER_GENERATION;
    
    // Adjust spawn parameters based on generation performance
    adjustSpawnParameters();
  }
  
  // Tournament selection
  Dino tournamentSelect(int tournamentSize) {
    Dino best = null;
    float bestScore = -1;
    
    for (int i = 0; i < tournamentSize; i++) {
      Dino contestant = dinos.get((int)random(dinos.size()));
      if (best == null || contestant.score > bestScore) {
        best = contestant;
        bestScore = contestant.score;
      }
    }
    
    return best;
  }
  
  // Dynamically adjust spawn parameters based on performance
  void adjustSpawnParameters() {
    // Adjust spawn timing based on score and generation
    if (last_gen_max_score > 1000) {
      MIN_SPAWN_MILLIS = max(1600, MIN_SPAWN_MILLIS - 100);
      MAX_SPAWN_MILLIS = max(2400, MAX_SPAWN_MILLIS - 100);
    } else if (last_gen_max_score > 500) {
      MIN_SPAWN_MILLIS = max(1800, MIN_SPAWN_MILLIS - 50);
      MAX_SPAWN_MILLIS = max(2600, MAX_SPAWN_MILLIS - 50);
    } else if (last_gen_max_score < 200) {
      MIN_SPAWN_MILLIS = min(2200, MIN_SPAWN_MILLIS + 100);
      MAX_SPAWN_MILLIS = min(3000, MAX_SPAWN_MILLIS + 100);
    }
    
    // Ensure reasonable bounds
    MIN_SPAWN_MILLIS = constrain(MIN_SPAWN_MILLIS, 1400, 2200);
    MAX_SPAWN_MILLIS = constrain(MAX_SPAWN_MILLIS, 2200, 3000);
  }
  float[] next_obstacle_info(Dino dino){
    float[] result = {1350, 1350, 450, 0, 0};  // Default values when no obstacle
    float closest_distance = 1350;
    Enemy closest_enemy = null;
    
    // Find the closest enemy ahead of the dino
    for (Enemy enemy : enemies){
      // Calculate distance from dino's front to enemy's front
      float dino_front = dino.x_pos + dino.obj_width;
      float enemy_front = enemy.x_pos + enemy.sprite_offset[0];
      float distance = enemy_front - dino_front;
      
      // Only consider obstacles ahead of the dino
      if (distance > -enemy.obj_width && distance < closest_distance) {
        closest_distance = distance;
        closest_enemy = enemy;
      }
    }
    
    // If we found a valid enemy, update the result with precise measurements
    if (closest_enemy != null) {
      result[0] = closest_distance;                                // Precise distance to obstacle
      result[1] = closest_enemy.x_pos;                            // Obstacle absolute x position
      result[2] = closest_enemy.y_pos + closest_enemy.sprite_offset[1];  // Corrected y position
      result[3] = closest_enemy.obj_width;                        // Obstacle width
      result[4] = closest_enemy.obj_height;                       // Obstacle height
    }
    
    return result;
  }
  
  void print() {
    if (showing_transition) {
      drawTransitionScreen();
      return;
    }
    
    ground.print();
    for (Enemy enemy : enemies) {
      enemy.print();
    }
    for (Dino dino : dinos) {
      dino.print();
    }
    print_info();
  }
  
  void drawInfoPanel() {
    // Simple panel background
    noStroke();
    fill(PANEL_COLOR);
    rect(20, 20, 300, 250, 8);
  }
  
  void print_info(){
    drawInfoPanel();
    drawStats();
    print_network();
  }
  
  void drawStats() {
    textAlign(LEFT);
    
    // Score display
    fill(TEXT_COLOR);
    textSize(40);
    text(nf(score, 5), 40, 70);
    
    // Generation info
    textSize(16);
    text("GENERATION " + generation, 40, 100);
    
    // Stats
    text("AVERAGE: " + last_gen_avg_score, 40, 140);
    text("HIGH SCORE: " + last_gen_max_score, 40, 170);
    
    // Simple population counter
    text("ALIVE: " + dinos_alive + "/" + DINOS_PER_GENERATION, 40, 200);
    
    // Basic progress bar
    noStroke();
    fill(NEUTRAL_COLOR);
    rect(40, 220, 260, 8);
    
    float progress = (float)dinos_alive / DINOS_PER_GENERATION;
    fill(ACCENT_COLOR);
    rect(40, 220, 260 * progress, 8);
  }

  void print_network() {
    for (Dino dino : dinos) {
      if (dino.alive) {
        dino.brain.print();
        break;
      }
    }
  }
  
  void tenth_of_second() {
    for (Dino dino : dinos) {
      if (dino.alive) {
        dino.toggle_sprite();
      }
    }
    score++;
  }
  
  void quarter_of_second() {
    for (Enemy enemy : enemies ) {
      enemy.toggle_sprite();
    }
  }
  void spawn_enemy() {
    // Dynamic obstacle patterns based on score and generation
    float birdProbability = 0.3;  // Base bird spawn chance
    float multipleObstacleProbability = 0.0; // Chance to spawn multiple obstacles
    
    // Increase difficulty based on score
    if (score > 500) {
      birdProbability = 0.35;
      multipleObstacleProbability = 0.2;
    }
    if (score > 1000) {
      birdProbability = 0.4;
      multipleObstacleProbability = 0.3;
    }
    if (score > 1500) {
      birdProbability = 0.45;
      multipleObstacleProbability = 0.4;
    }
    
    // Spawn main obstacle
    if (random(1) > birdProbability) {
      enemies.add(new Cactus());
    } else {
      enemies.add(new Bird());
    }
    
    // Possibly spawn additional obstacles
    if (random(1) < multipleObstacleProbability) {
      // Add a second obstacle with spacing
      float spacing = random(200, 400);
      Enemy second;
      if (random(1) > 0.5) {
        second = new Cactus();
      } else {
        second = new Bird();
      }
      second.x_pos += spacing;
      enemies.add(second);
    }
  }
    void drawTransitionScreen() {
    float currentTime = millis() - transition_start_time;
    float fadeInAlpha = min(255, currentTime * 0.5);
    float fadeOutAlpha = max(0, 255 - (currentTime - 1500) * 0.5);
    float alpha = min(fadeInAlpha, fadeOutAlpha);
    
    // Animated background with grid effect
    background(BACKGROUND_COLOR);
    stroke(TEXT_COLOR, 5);
    strokeWeight(1);
    for (int i = 0; i < width; i += 50) {
      float offset = sin(frameCount * 0.02 + i * 0.01) * 5;
      line(i, 0, i + offset, height);
    }
    for (int i = 0; i < height; i += 50) {
      float offset = sin(frameCount * 0.02 + i * 0.01) * 5;
      line(0, i, width, i + offset);
    }
    
    // Semi-transparent overlay with gradient
    noStroke();
    for (int i = 0; i < height; i += 4) {
      float gradientAlpha = map(i, 0, height, 150, 50);
      fill(BACKGROUND_COLOR, gradientAlpha * alpha/255);
      rect(0, i, width, 4);
    }
    
    // Generation title with glow effect
    textAlign(CENTER);
    textSize(64);
    // Glow effect
    for (int i = 0; i < 3; i++) {
      float glowSize = map(i, 0, 2, 4, 0);
      fill(ACCENT_COLOR, (alpha/3) * (1-i/3.0));
      text("Generation " + generation, width/2 + glowSize, height/2 - 70 + glowSize);
    }
    // Main text
    fill(ACCENT_COLOR, alpha);
    text("Generation " + generation, width/2, height/2 - 70);
    
    if (generation > 1) {
      // Stats panel with modern style
      float panelWidth = 400;
      float panelHeight = 180;
      float panelX = width/2 - panelWidth/2;
      float panelY = height/2 - 20;
      
      // Panel background with gradient
      noStroke();
      fill(PANEL_COLOR, alpha * 0.9);
      rect(panelX, panelY, panelWidth, panelHeight, 12);
      
      // Panel border glow
      noFill();
      for (int i = 0; i < 3; i++) {
        stroke(ACCENT_COLOR, alpha * (0.1 - i * 0.03));
        strokeWeight(i * 2 + 1);
        rect(panelX, panelY, panelWidth, panelHeight, 12);
      }
      
      // Stats content
      textAlign(LEFT);
      textSize(24);
      
      // Headers with accent colors
      fill(ACCENT_COLOR, alpha);
      text("Previous Generation Stats", panelX + 30, panelY + 40);
      
      // Stats with modern labels
      textSize(20);
      float statY = panelY + 80;
      
      // Average score
      fill(TEXT_COLOR, alpha * 0.7);
      text("Average Score", panelX + 30, statY);
      fill(NODE_COLOR, alpha);
      text(last_gen_avg_score, panelX + 220, statY);
      
      // High score
      fill(TEXT_COLOR, alpha * 0.7);
      text("High Score", panelX + 30, statY + 40);
      fill(NODE_ACTIVE, alpha);
      text(last_gen_max_score, panelX + 220, statY + 40);
      
      // Population stats
      fill(TEXT_COLOR, alpha * 0.7);
      text("Population", panelX + 30, statY + 80);
      fill(ACCENT_COLOR, alpha);
      text(DINOS_PER_GENERATION + " dinos", panelX + 220, statY + 80);
    }
    
    // Progress bar at the bottom
    float progress = min(1, currentTime / 2000);
    noStroke();
    fill(NEUTRAL_COLOR, alpha * 0.3);
    rect(width/2 - 200, height - 40, 400, 4, 2);
    
    // Gradient progress bar
    for (float i = 0; i < progress * 400; i++) {
      float gradientProgress = i / 400;
      color barColor = lerpColor(NODE_ACTIVE, ACCENT_COLOR, gradientProgress);
      stroke(barColor, alpha);
      line(width/2 - 200 + i, height - 40, width/2 - 200 + i, height - 37);
    }
    
    // Add glowing dot at progress end
    if (progress < 1) {
      float dotX = width/2 - 200 + (progress * 400);
      noStroke();
      // Outer glow
      fill(ACCENT_COLOR, alpha * 0.2);
      circle(dotX, height - 38, 12);
      // Inner dot
      fill(ACCENT_COLOR, alpha);
      circle(dotX, height - 38, 6);
    }
    
    // Check if transition should end (2 seconds)
    if (currentTime > 2000) {
      showing_transition = false;
    }
  }
}
