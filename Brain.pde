class Brain {
  
  float[] inputs;
  float[] outputs = {0, 0};  // Initialize outputs to no action
  float[][] hidden_layer_weights;
  float[] hidden_layer_bias;
  float[] hidden_outputs;
  float[][] output_layer_weights;
  float[] output_layer_bias;
  
  Brain(Genome genome) {
    // Initialize weight matrices
    hidden_layer_weights = zeroes_matrix(7, 7);
    output_layer_weights = zeroes_matrix(2, 7);
    
    // Apply genome's weights to matrices
    for (Gen gen : genome.genes) {
      if (gen.source_hidden_layer) {
        // Input to hidden layer connections
        if (gen.id_source_neuron < 7 && gen.id_target_neuron < 7) {
          hidden_layer_weights[gen.id_target_neuron][gen.id_source_neuron] = gen.weight;
        }
      } else {
        // Hidden to output layer connections
        if (gen.id_source_neuron < 7 && gen.id_target_neuron < 2) {
          output_layer_weights[gen.id_target_neuron][gen.id_source_neuron] = gen.weight;
        }
      }
    }
    
    hidden_layer_bias = genome.hidden_layer_bias;
    output_layer_bias = genome.output_layer_bias;
  }
  
  void feed_forward(float[] input_layer_values) {
    inputs = input_layer_values;
    
    // Process hidden layer
    hidden_outputs = matrix_vector_multiplication(hidden_layer_weights, input_layer_values);
    for (int i = 0; i < hidden_outputs.length; i++) {
      hidden_outputs[i] += hidden_layer_bias[i];
      hidden_outputs[i] = tanh(hidden_outputs[i]);  // Use tanh for better gradients
    }
    
    // Process output layer
    outputs = matrix_vector_multiplication(output_layer_weights, hidden_outputs);
    for (int i = 0; i < outputs.length; i++) {
      outputs[i] += output_layer_bias[i];
      outputs[i] = sigmoid(outputs[i]);  // Use sigmoid for 0-1 range
    }
  }
  
  float tanh(float x) {
    float ex = exp(x);
    float enx = exp(-x);
    return (ex - enx) / (ex + enx);
  }
  
  float sigmoid(float x) {
    return 1.0 / (1.0 + exp(-x));
  }

  float ReLU(float x) {
    return max(0, x);
  }
  void set_neural_connection_stroke(float weight, boolean isOutputConnection){
    if (isOutputConnection) {
      // Use peach for positive and pink for negative weights in output connections
      color connectionColor = weight > 0 ? NODE_ACTIVE : SECONDARY_COLOR;
      stroke(connectionColor, map(abs(weight), 0, 1, 70, 255));
    } else {
      // Use cyan with gradient for hidden connections
      color connectionColor = lerpColor(NEUTRAL_COLOR, NODE_COLOR, abs(weight));
      stroke(connectionColor, map(abs(weight), 0, 1, 70, 255));
    }
    weight = abs(weight);
    weight = map(weight, 0, 1, 1, 4);
    strokeWeight(weight);
  }
    void print() {
    // Draw minimal panel in Chrome style
    noStroke();
    fill(PANEL_COLOR);
    rect(520, 20, 420, 320, 8);
    
    // Subtle border in Chrome style
    stroke(TEXT_COLOR, 15);
    strokeWeight(1);
    noFill();
    rect(520, 20, 420, 320, 8);
      // Draw network title in Chrome style
    fill(TEXT_COLOR);
    textAlign(CENTER);
    textSize(14);
    text("NEURAL NETWORK", 730, 45);
    
    // Draw network labels in Chrome style
    textAlign(LEFT);
    textSize(12);
    fill(TEXT_COLOR, 150);
    text("INPUTS", 550, 80);
    text("HIDDEN", 750, 80);
    text("OUTPUTS", 850, 80);
    
    // Draw the neural network connections and nodes    // Draw connections first with layered effect
    for (int i = 0; i < 7; i++){
      // Input layer to hidden layer lines
      for (int j = 0; j < 7; j++){
        float weight = hidden_layer_weights[i][j];
        set_neural_connection_stroke(weight, false);
        line(600 + 16, 100+i*35, 700 - 16, 100+j*35);
      }
      // Hidden layer to output layer lines (decision connections)
      for (int j = 0; j < 2; j++){
        float weight = output_layer_weights[j][i];
        set_neural_connection_stroke(weight, true);
        line(700 + 16, 100 + i * 35, 800 - 16, 165 + j * 40);
      }
    }    // Draw nodes with enhanced visual style
    for (int i = 0; i < 7; i++){
      // Input layer nodes
      // Draw outer glow for input nodes
      noStroke();
      fill(NODE_COLOR, 20);
      circle(600, 100 + i * 35, 28);
      
      // Main node circle
      stroke(NODE_COLOR);
      strokeWeight(2);
      fill(PANEL_COLOR);
      circle(600, 100 + i * 35, 24);
        // Inner glow effect
      noStroke();
      for(int g = 0; g < 3; g++) {
        fill(NODE_COLOR, 10);
        circle(600, 100 + i * 35, 16 + g*2);
      }
      
      // Hidden layer nodes with enhanced activation indication
      // Outer glow with multiple layers
      for(int g = 0; g < 3; g++) {
        fill(NODE_COLOR, 10);
        circle(700, 100 + i * 35, 28 + g*2);
      }
      
      // Main node circle
      stroke(NODE_COLOR);
      strokeWeight(2);
      if (hidden_outputs[i] == 0){
        fill(PANEL_COLOR);
      } else {
        fill(NODE_COLOR, map(hidden_outputs[i], 0, 1, 100, 255));
      }
      circle(700, 100 + i * 35, 24);
      
      // Inner highlight
      noStroke();
      if (hidden_outputs[i] > 0) {
        fill(255, 50);
        circle(700, 100 + i * 35, 16);
      }
      
      // Input values with better contrast
      textAlign(RIGHT);
      textSize(12);
      fill(TEXT_COLOR);
      text(nf(inputs[i], 0, 2), 580, 105 + i * 35);
    }
    
    // Output nodes with decision coloring
    for (int i = 0; i < 2; i++) {
      // Outer glow
      noStroke();
      fill(outputs[i] > 0 ? ACCENT_COLOR : SECONDARY_COLOR, 20);
      circle(800, 165 + i * 40, 28);
        // Main node circle with new color scheme
      stroke(outputs[i] > 0 ? NODE_ACTIVE : SECONDARY_COLOR);
      strokeWeight(2);
      if (outputs[i] == 0){
        fill(PANEL_COLOR);
      } else {
        fill(outputs[i] > 0 ? NODE_ACTIVE : SECONDARY_COLOR, map(outputs[i], 0, 1, 100, 255));
      }
      circle(800, 165 + i * 40, 24);
      
      // Enhanced glow effect for active nodes
      if (outputs[i] > 0) {
        noFill();
        stroke(outputs[i] > 0 ? NODE_ACTIVE : SECONDARY_COLOR, 40);
        circle(800, 165 + i * 40, 32);
        circle(800, 165 + i * 40, 28);
      }
      
      // Output labels
      fill(TEXT_COLOR);
      textAlign(LEFT);
      text(i == 0 ? "Jump" : "Crouch", 830, 170 + i * 40);
    }
  }
  
}
