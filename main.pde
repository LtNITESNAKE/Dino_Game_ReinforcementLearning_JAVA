import java.util.Collections;
import java.util.Iterator;

// High-contrast color scheme for projector visibility
color BACKGROUND_COLOR = #1A1B1E;    // Dark background
color TEXT_COLOR = #FFFFFF;          // White text
color ACCENT_COLOR = #4DABF7;        // Bright blue
color SECONDARY_COLOR = #FF6B6B;     // Coral red
color NEUTRAL_COLOR = #868E96;       // Medium gray
color NODE_COLOR = #748FFC;          // Bright purple
color NODE_ACTIVE = #51CF66;         // Bright green
color PANEL_COLOR = #25262B;         // Dark panel background

HashMap<String, PImage> game_sprites = new HashMap<String, PImage>();
PFont gameFont;
Simulation simulation;
float fadeAlpha = 0;
boolean showingTitle = true;
int startTime;
int tenth = 0;
int clock = 0;

void setup() {
  size(1280, 720);
  frameRate(60);
  gameFont = createFont("Arial Bold", 16);
  textFont(gameFont);
  initialize_sprites();
  simulation = new Simulation();
  startTime = millis();
}

void draw() {
  // Draw animated background
  background(BACKGROUND_COLOR);
  drawAnimatedBackground();
  
  if (showingTitle && millis() - startTime < 3000) {
    drawTitleScreen();
  } else {
    showingTitle = false;
    simulation.update();
    simulation.print();
    if (!simulation.showing_transition) {
      drawGridOverlay();
    }
  }
  
  if (millis() - tenth > 50) {
    tenth = millis();
    clock++;
    if (clock % 2 == 0) {
      simulation.tenth_of_second();
    }
    if (clock % 5 == 0) {
      simulation.quarter_of_second();
    }
  }
}

void drawTitleScreen() {
  fadeAlpha = min(255, (millis() - startTime) * 0.5);
  
  textAlign(CENTER);
  textSize(48);
  fill(ACCENT_COLOR, fadeAlpha);
  text("Dino AI Evolution", width/2, height/2 - 50);
  
  textSize(24);
  fill(TEXT_COLOR, fadeAlpha);
  text("Neural Network Learning Demonstration", width/2, height/2 + 20);
  
  textSize(16);
  fill(NEUTRAL_COLOR, fadeAlpha);
  text("Generation: " + simulation.generation, width/2, height/2 + 60);
}

void drawAnimatedBackground() {
  // Create subtle animated gradient
  float t = millis() * 0.001;
  for (int y = 0; y < height; y += 4) {
    float alpha = map(y, 0, height, 20, 5);
    stroke(ACCENT_COLOR, alpha);
    float offset = sin(t + y * 0.01) * 20;
    line(0, y, width, y + offset);
  }
}

void drawGridOverlay() {
  // Draw subtle grid lines
  stroke(TEXT_COLOR, 5);
  strokeWeight(1);
  
  // Vertical lines with parallax effect
  for (int x = 0; x < width; x += 50) {
    float offset = (x + frameCount) % width;
    float alpha = map(sin(offset * 0.01), -1, 1, 2, 8);
    stroke(TEXT_COLOR, alpha);
    line(offset, 0, offset, height);
  }
  
  // Horizontal lines
  for (int y = 0; y < height; y += 50) {
    stroke(TEXT_COLOR, 3);
    line(0, y, width, y);
  }
}

void initialize_sprites(){
  PImage sprite_sheet = loadImage("sprites.png");
  game_sprites.put("standing_dino", sprite_sheet.get(1338, 2, 88, 94));
  game_sprites.put("walking_dino_1", sprite_sheet.get(1514, 2, 88, 94));
  game_sprites.put("walking_dino_2", sprite_sheet.get(1602, 2, 88, 94));
  game_sprites.put("dead_dino", sprite_sheet.get(1690, 2, 88, 94));
  game_sprites.put("crouching_dino_1", sprite_sheet.get(1866, 36, 118, 60));
  game_sprites.put("crouching_dino_2", sprite_sheet.get(1984, 36, 118, 60));
  game_sprites.put("cactus_type_1", sprite_sheet.get(446, 2, 34, 70));
  game_sprites.put("cactus_type_2", sprite_sheet.get(480, 2, 68, 70));
  game_sprites.put("cactus_type_3", sprite_sheet.get(548, 2, 102, 70));
  game_sprites.put("cactus_type_4", sprite_sheet.get(652, 2, 50, 100));
  game_sprites.put("cactus_type_5", sprite_sheet.get(702, 2, 100, 100));
  game_sprites.put("cactus_type_6", sprite_sheet.get(802, 2, 150, 100));
  game_sprites.put("bird_flying_1", sprite_sheet.get(260, 2, 92, 80));
  game_sprites.put("bird_flying_2", sprite_sheet.get(352, 2, 92, 80));
  game_sprites.put("ground", sprite_sheet.get(2, 104, 2400, 24));
}
