class Gen {
  
  boolean source_hidden_layer;
  int id_source_neuron;
  int id_target_neuron;
  float weight;
    Gen(){
    // Bias towards input-hidden connections initially
    source_hidden_layer = (random(1) < 0.4);  // 60% chance of input-hidden connection
    id_source_neuron = (int)random(0, 7);
    
    if (source_hidden_layer){
      id_target_neuron = (int)random(0, 7);
    } else {
      id_target_neuron = (int)random(0, 2);
    }
    
    // Initialize weights with targeted bias based on connection type
    if (id_target_neuron == 0 && !source_hidden_layer) {  // Jump output
      if (id_source_neuron == 0) { // Distance input
        weight = random(0.4, 1.0);  // Strong positive bias for distance
      } else if (id_source_neuron == 2 || id_source_neuron == 4) { // Height inputs
        weight = random(0.3, 0.8);  // Moderate positive bias for height
      } else {
        weight = random(0.1, 0.6);  // Lower bias for other inputs
      }
    } else if (id_target_neuron == 1 && !source_hidden_layer) {  // Crouch output
      if (id_source_neuron == 2) { // Height position is important for crouching
        weight = random(0.3, 0.7);  // Stronger bias for height detection
      } else {
        weight = random(-0.2, 0.2);  // Small random weights for other inputs
      }
    } else {
      // Hidden layer connections with varied initialization
      if (id_source_neuron == 0 || id_source_neuron == 2) {
        weight = random(-0.6, 0.6);  // Larger range for important inputs
      } else {
        weight = random(-0.4, 0.4);  // Smaller range for other inputs
      }
    }
  }
  
}

class Genome {
  
  int length;
  ArrayList<Gen> genes;
  float[] hidden_layer_bias;
  float[] output_layer_bias;
  Genome(){
    // Increase initial connections for better learning
    length = 28;  // More initial connections
    genes = new ArrayList<Gen>();
    for (int i = 0; i < length; i++){
      genes.add(new Gen());
    }
    // Initialize biases with small values for better initial behavior
    hidden_layer_bias = new float[7];
    output_layer_bias = new float[2];
    for (int i = 0; i < 7; i++) {
      hidden_layer_bias[i] = random(-0.5, 0.5);
    }
    for (int i = 0; i < 2; i++) {
      output_layer_bias[i] = random(-0.5, 0.5);
    }
  }

  Genome copy(){
    Genome copy = new Genome();
    copy.genes.clear();  // Clear default genes
    for (Gen gene : genes){
      Gen newGene = new Gen();
      newGene.source_hidden_layer = gene.source_hidden_layer;
      newGene.id_source_neuron = gene.id_source_neuron;
      newGene.id_target_neuron = gene.id_target_neuron;
      newGene.weight = gene.weight;
      copy.genes.add(newGene);
    }
    copy.length = length;
    
    for (int i = 0; i < 7; i++){
      copy.hidden_layer_bias[i] = hidden_layer_bias[i];
    }
    for (int i = 0; i < 2; i++){
      copy.output_layer_bias[i] = output_layer_bias[i];
    }
    return copy;
  }
    Genome mutate() {
    Genome mutated_genome = copy();
    
    // Mutate genes with adaptive rates
    for (int i = 0; i < length; i++) {
      if (random(1) < 0.25) { // 25% chance to mutate each gene
        Gen newGene = new Gen();
        
        // 80% chance to keep the same connection but adjust weight
        if (random(1) < 0.8) {
          newGene.source_hidden_layer = genes.get(i).source_hidden_layer;
          newGene.id_source_neuron = genes.get(i).id_source_neuron;
          newGene.id_target_neuron = genes.get(i).id_target_neuron;
          
          // More controlled weight adjustments
          float mutation_range = random(0.3, 0.6); // Varying mutation strength
          newGene.weight = genes.get(i).weight + random(-mutation_range, mutation_range);
          newGene.weight = constrain(newGene.weight, -1, 1);
        }
        
        mutated_genome.genes.set(i, newGene);
      }
    }
    
    // Mutate bias values with small, controlled adjustments
    for (int i = 0; i < 7; i++) {
      if (random(1) < 0.2) {
        mutated_genome.hidden_layer_bias[i] += random(-0.2, 0.2);
        mutated_genome.hidden_layer_bias[i] = constrain(mutated_genome.hidden_layer_bias[i], -0.8, 0.8);
      }
    }
    
    for (int i = 0; i < 2; i++) {
      if (random(1) < 0.15) { // Less frequent output bias mutations
        mutated_genome.output_layer_bias[i] += random(-0.15, 0.15);
        mutated_genome.output_layer_bias[i] = constrain(mutated_genome.output_layer_bias[i], -0.8, 0.8);
      }
    }
    
    return mutated_genome;
  }

  Genome crossover(Genome anotherGenome) {
    Genome crossed_genome = copy();
    
    // Crossover genes with intelligent mixing
    for (int i = 0; i < length; i++){
      // Take better performing connections more often
      if (random(1) < 0.4) { // 40% chance to take gene from other parent
        Gen otherGene = anotherGenome.genes.get(i);
        Gen newGene = new Gen();
        newGene.source_hidden_layer = otherGene.source_hidden_layer;
        newGene.id_source_neuron = otherGene.id_source_neuron;
        newGene.id_target_neuron = otherGene.id_target_neuron;
        newGene.weight = otherGene.weight;
        crossed_genome.genes.set(i, newGene);
      }
    }
    
    // Crossover bias values with averaging
    for (int i = 0; i < 7; i++){
      if (random(1) < 0.5) {
        // Average the bias values between parents
        crossed_genome.hidden_layer_bias[i] = 
          (hidden_layer_bias[i] + anotherGenome.hidden_layer_bias[i]) / 2;
      }
    }
    for (int i = 0; i < 2; i++){
      if (random(1) < 0.5) {
        crossed_genome.output_layer_bias[i] = 
          (output_layer_bias[i] + anotherGenome.output_layer_bias[i]) / 2;
      }
    }
    
    return crossed_genome;
  }
}
