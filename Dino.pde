class Dino extends GameObject implements Comparable<Dino>{
  
  float jump_stage;
  boolean alive = true;
  int score;
  float[] current_obstacle_info; // Store current obstacle info
  int current_speed; // Store current speed

  Genome genome;
  Brain brain;
  float[] brain_inputs = new float[7];

  Dino() {
    x_pos = (int)random(100, 300);
    y_pos = 450;
    obj_width = 80;
    obj_height = 86;
    current_speed = 3; // Initial speed
    
    genome = new Genome();
    init_brain();
    jump_stage = 0;
    
    sprite = "walking_dino_1";
    sprite_offset[0] = -4;
    sprite_offset[1] = -2;
  }

  void init_brain() {
    brain = new Brain(genome);
  }
  void print() {
    if (alive) {
      // Just draw the sprite - no effects for better performance
      image(game_sprites.get(sprite), 
            x_pos + sprite_offset[0], 
            y_pos + sprite_offset[1]);
    }
  }
  
  void update(float[] next_obstacle_info, int speed) {
    current_obstacle_info = next_obstacle_info;
    current_speed = speed;
    update_brain_inputs(next_obstacle_info, speed);
    brain.feed_forward(brain_inputs);
    process_brain_output();
    if (jumping()) {
      update_jump();
    }
  }  void update_brain_inputs(float[] next_obstacle_info, int speed) {
    // Calculate precise distance considering sprite offsets
    float dino_front = x_pos + obj_width;
    float obstacle_front = next_obstacle_info[1] + 4; // Add small offset for collision margin
    float raw_distance = obstacle_front - dino_front;
    
    // Normalize distance with speed-based scaling
    float distance_scale = 900 + (speed * 15); // Increase lookahead at higher speeds
    brain_inputs[0] = constrain(raw_distance / distance_scale, 0, 1);
    
    // Normalize x position relative to dino's position for better context
    float relative_x = next_obstacle_info[1] - x_pos;
    brain_inputs[1] = constrain(relative_x / 900, 0, 1);
    
    // Enhanced height normalization for better obstacle type detection
    float obstacle_y = next_obstacle_info[2];
    float height_factor = (515 - obstacle_y) / 145.0;
    brain_inputs[2] = constrain(height_factor, 0, 1);
    
    // Width normalization with speed consideration
    float width_scale = 1 + (speed / 13.0) * 0.3; // Subtle speed scaling
    brain_inputs[3] = constrain((next_obstacle_info[3] * width_scale) / 146.0, 0, 1);
    
    // Height input normalized with speed consideration
    float height_scale = 1 + (speed / 13.0) * 0.2;
    brain_inputs[4] = constrain((next_obstacle_info[4] * height_scale) / 96.0, 0, 1);
    
    // Dino's vertical position relative to ground
    brain_inputs[5] = constrain((y_pos - 278) / (484 - 278), 0, 1);
    
    // Speed normalization with better scaling
    brain_inputs[6] = constrain(speed / 30.0, 0, 1);
  }

  void process_brain_output() {
    final float JUMP_THRESHOLD = 0.48;    // Slightly more eager to jump
    final float CROUCH_THRESHOLD = 0.55;  // More conservative crouching
    
    // Get precise distance information
    float raw_distance = current_obstacle_info[0];
    float obstacle_height = current_obstacle_info[4];
    
    // Calculate jump window with speed and height consideration
    float base_distance = 140;  // Base optimal jump distance
    float speed_factor = current_speed * 5;
    float height_factor = obstacle_height * 0.5;
    
    float optimal_jump_distance = base_distance + speed_factor + height_factor;
    float jump_window = 50 + (current_speed * 2); // Smaller window for more precise jumps
    
    // More precise jump timing
    if (raw_distance < optimal_jump_distance + jump_window && 
        raw_distance > optimal_jump_distance - jump_window) {
      if (brain.outputs[0] > JUMP_THRESHOLD) {
        // Only jump if we're on the ground and not already jumping/crouching
        if (!jumping() && !crouching() && y_pos >= 445) {
          jump();
        }
      }
    }
    
    // Improved crouch logic for birds
    boolean is_bird = current_obstacle_info[2] < 450; // Check if obstacle is elevated
    if (brain.outputs[1] > CROUCH_THRESHOLD && is_bird) {
      if (!jumping()) {
        crouch();
      }
    } else if (crouching()) {
      stop_crouch();
    }
  }

  void update_jump() {
    float GRAVITY = 0.9;
    float INITIAL_VELOCITY = 21; // Slightly stronger initial jump
    
    if (jump_stage == 0.0001) {
      y_pos -= INITIAL_VELOCITY;
      jump_stage = 0.1;
    } else {
      float time_factor = jump_stage * 60;
      float velocity = INITIAL_VELOCITY - (GRAVITY * time_factor);
      
      // Refined speed-based jump adjustment
      float speed_adjustment = map(current_speed, 3, 13, 0, 1.2);
      velocity += speed_adjustment;
      
      y_pos -= velocity;
      
      // More precise ground detection
      if (y_pos >= 450) {
        stop_jump();
      } else {
        jump_stage += 1/60.0;
      }
    }
  }
  
  void jump(){
    if (!jumping()) {
      jump_stage = 0.0001;
      sprite = "standing_dino";
    }
  }
  
  void stop_jump() {
    jump_stage = 0;
    y_pos = 450;
    sprite = "walking_dino_1";
  }
  
  void crouch(){
    if ( !crouching() ) {
      y_pos = 484;
      obj_width = 110;
      obj_height = 52;
      sprite = "crouching_dino_1";
    }
  }
  
  void stop_crouch(){
    y_pos = 450;
    obj_width = 80;
    obj_height = 86;
    sprite = "walking_dino_1";
  }
  
  boolean jumping() {
    return jump_stage > 0;
  }
  
  boolean crouching() {
    return obj_width == 110;
  }

  void die(int sim_score) {
    alive = false;
    score = sim_score;
  }

  void reset() {
    alive = true;
    score = 0;
  }
  
  void toggle_sprite() {
    if ( sprite.equals("walking_dino_1") ) {
      sprite = "walking_dino_2";
    } else if ( sprite.equals("walking_dino_2") ) {
      sprite = "walking_dino_1";
    } else if ( sprite.equals("crouching_dino_1") ) {
      sprite = "crouching_dino_2";
    } else if ( sprite.equals("crouching_dino_2") ) {
      sprite = "crouching_dino_1";
    }
  }
  
  @Override
  public int compareTo(Dino otherDino) {
    return Integer.compare(this.score, otherDino.score);
  }
}
