abstract class Enemy extends GameObject {
  
  Enemy() {
    x_pos = 1350;
  }
  
  void update(int speed) {
    x_pos -= speed;
  }
  
  void print() {
    // Just draw sprite - no effects for better performance
    image(game_sprites.get(sprite), x_pos + sprite_offset[0], y_pos + sprite_offset[1]);
  }
  
  boolean is_offscreen() {
    return x_pos + obj_width < 0;
  }
}

class Cactus extends Enemy {

  int type;
  // Adjusted widths for more accurate collision
  int[] cactus_widths = {28, 62, 94, 42, 92, 142}; // Slightly reduced from sprite width
  int[] cactus_heights = {66, 66, 66, 96, 96, 96};
  int[] cactus_y_pos = {470, 470, 470, 444, 444, 444};
  
  Cactus() {
    type = (int)random(6);
    obj_width = cactus_widths[type] + 2;  // Small padding for collision
    obj_height = cactus_heights[type] + 2;
    y_pos = cactus_y_pos[type];
    sprite = "cactus_type_" + (type + 1);
    
    // Adjusted offsets for better hitbox alignment
    sprite_offset[0] = -1;
    sprite_offset[1] = -1;
  }
  
  void print() {
    super.print();
  }
}

class Bird extends Enemy {
  float hoverOffset;
  int type;
  int[] birds_y_pos = {435, 480, 370};
  
  Bird() {
    x_pos = 1350;
    obj_width = 84;    // Slightly smaller width for more accurate collision
    obj_height = 40;   // Smaller height to match actual bird body
    type = (int)random(3);
    y_pos = birds_y_pos[type];
    sprite = "bird_flying_1";
    sprite_offset[0] = -4;
    sprite_offset[1] = -16;
    hoverOffset = 0;
  }
  
  void update(int speed) {
    super.update(speed);
    // Smoother hover motion
    hoverOffset = sin(frameCount * 0.1) * 4;
    // Adjust vertical position with hover
    y_pos += hoverOffset;
  }
  
  void print() {
    image(game_sprites.get(sprite), x_pos + sprite_offset[0], y_pos + sprite_offset[1]);
    // Reset y_pos after drawing to prevent accumulation
    y_pos -= hoverOffset;
  }
  
  void toggle_sprite() {
    if (sprite.equals("bird_flying_1")) {
      sprite = "bird_flying_2";
    } else {
      sprite = "bird_flying_1";
    }
  }
}
