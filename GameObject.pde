abstract class GameObject {
  
  float x_pos, y_pos;
  float obj_width, obj_height;
  String sprite;
  int[] sprite_offset = {0, 0};
  
  void print() {
    // Draw the sprite
    image(game_sprites.get(sprite), x_pos + sprite_offset[0], y_pos + sprite_offset[1]);
  }
    
  boolean is_collisioning_with(GameObject anObject) {
    // Calculate precise hitboxes with sprite offsets
    float thisLeft = x_pos + sprite_offset[0] + 4;  // Add small padding
    float thisRight = thisLeft + obj_width - 8;     // Subtract padding for tighter hitbox
    float thisTop = y_pos + sprite_offset[1] + 4;
    float thisBottom = thisTop + obj_height - 8;
    
    float otherLeft = anObject.x_pos + anObject.sprite_offset[0] + 4;
    float otherRight = otherLeft + anObject.obj_width - 8;
    float otherTop = anObject.y_pos + anObject.sprite_offset[1] + 4;
    float otherBottom = otherTop + anObject.obj_height - 8;
    
    // For bird, use a more precise hitbox
    if (anObject instanceof Bird) {
      otherTop += 12;     // Adjust top to account for wing animation
      otherBottom -= 12;  // Adjust bottom to account for wing animation
      otherLeft += 8;     // Adjust left side to account for bird's beak
      otherRight -= 8;    // Adjust right side for tighter collision
    }
    
    // Debug visualization of hitboxes (uncomment if needed)
    /*
    stroke(255, 0, 0);
    noFill();
    rect(thisLeft, thisTop, thisRight - thisLeft, thisBottom - thisTop);
    rect(otherLeft, otherTop, otherRight - otherLeft, otherBottom - otherTop);
    */
    
    // Check for overlap on both axes
    boolean horizontalOverlap = (thisRight > otherLeft && thisLeft < otherRight);
    boolean verticalOverlap = (thisBottom > otherTop && thisTop < otherBottom);
    
    return horizontalOverlap && verticalOverlap;
  }
  
  void toggle_sprite() {}
}

class Ground extends GameObject {
 
  Ground() {
    x_pos = 2400;
    y_pos = 515;
    sprite = "ground";
  }

  void update(int speed) {
    x_pos -= speed;
    if (x_pos <= 0) {
      x_pos = 2400;
    }
  }
  
  void print() {
    // Draw ground with a subtle gradient
    noStroke();
    fill(NEUTRAL_COLOR, 30);
    rect(0, y_pos, width, height - y_pos);
    
    // Draw the ground sprites
    tint(TEXT_COLOR, 200);
    image(game_sprites.get(sprite), x_pos, y_pos);
    image(game_sprites.get(sprite), x_pos - 2400, y_pos);
    noTint();
  }
  
}
