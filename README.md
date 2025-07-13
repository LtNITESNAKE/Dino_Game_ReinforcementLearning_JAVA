# Chrome Dinosaur Game AI - Neural Evolution

A Java-based implementation using Processing that trains AI agents to play the Chrome Dinosaur game through **neuroevolution** - combining neural networks with genetic algorithms. This project demonstrates how artificial intelligence can learn complex behaviors through simulated evolution, watching a population of dinosaurs evolve from random jumping to skilled obstacle avoidance.

## Overview

This project recreates the classic Chrome Dinosaur game and uses **genetic algorithms** to evolve neural networks that control the dinosaurs. Unlike traditional reinforcement learning approaches, this system mimics natural evolution where the best-performing dinosaurs pass their "genes" (neural network weights) to the next generation, with mutations and crossover creating new combinations.

Think of it like breeding race horses - we start with a random population, select the fastest runners, breed them together, and over many generations, the population becomes faster and more skilled. Here, our "horses" are dinosaurs, and their "speed" is their ability to avoid obstacles.

## Key Features

- **Complete Chrome Dino Game Recreation**: Full game implementation with physics, collision detection, and obstacle spawning
- **Neural Network Agents**: Each dinosaur has its own "brain" - a neural network that processes game state and makes decisions
- **Genetic Evolution**: Population evolves over generations through selection, crossover, and mutation
- **Real-time Visualization**: Watch both the game and the neural networks in action
- **Population Management**: Manages 100 dinosaurs per generation with intelligent breeding strategies
- **Performance Analytics**: Track evolution progress with detailed statistics and metrics

## How It Works

### The Learning Process

Instead of teaching one dinosaur how to play, we create 100 dinosaurs and let them learn through evolution:

1. **Initial Population**: 100 dinosaurs with random neural networks (they jump and crouch randomly)
2. **Natural Selection**: Let them play until they all die, measuring how long each survived
3. **Breeding**: The best performers get to "reproduce" - their neural networks are combined to create offspring
4. **Mutation**: Small random changes are made to prevent the population from becoming too similar
5. **New Generation**: The cycle repeats with a new population that's slightly better than the last

This process mirrors how biological evolution works, but accelerated into just a few minutes instead of millions of years.

### Neural Network Architecture

Each dinosaur has a neural network "brain" with three layers:

**Input Layer (7 neurons)** - The dinosaur's "senses":
- Distance to the next obstacle
- Obstacle's x and y position
- Obstacle width and height  
- Dinosaur's current vertical position
- Current game speed

**Hidden Layer (7 neurons)** - Processing and pattern recognition:
- Uses hyperbolic tangent (tanh) activation function
- Processes sensory information into meaningful patterns
- Learns to recognize different obstacle types and situations

**Output Layer (2 neurons)** - Decision making:
- Jump decision (activates when output > 0.48)
- Crouch decision (activates when output > 0.55)
- Uses sigmoid activation for clear yes/no decisions

### Genetic Algorithm Components

**Selection Methods**:
- **Elite Selection**: Top 10% of performers automatically survive to breed
- **Tournament Selection**: Groups of 3 dinosaurs compete, winner gets to reproduce
- This ensures both preservation of good traits and genetic diversity

**Breeding Process**:
- 70% chance of crossover (mixing two parents' neural networks)
- 30% chance of copying one parent directly
- Offspring inherit combinations of their parents' decision-making abilities

**Mutation System**:
- Small random changes to neural network weights
- Prevents population from becoming too similar
- Allows discovery of new strategies
- Carefully balanced to avoid destroying good solutions

## Project Structure

```
Chrome_Dinosaur_Game_AI/
├── main.pde                   # Entry point and game loop
├── Simulation.pde            # Evolution manager and game environment
├── Dino.pde                  # Individual dinosaur agents
├── Brain.pde                 # Neural network implementation
├── Genome.pde                # Genetic encoding and evolution operators
├── Enemy.pde                 # Obstacle classes (Cactus, Bird)
├── GameObject.pde            # Base class for game entities
├── LinearAlgebra.pde         # Matrix operations for neural networks
├── data/
│   └── sprites.png           # Game sprite sheet
└── README.md                 # This file
```

## Prerequisites

- **Processing IDE 3.0+** (not regular Java - this uses the Processing framework)
- **Java 8 or higher** (Processing requirement)

## Installation and Usage

1. **Download Processing**: Get it from [processing.org](https://processing.org/download/)

2. **Clone the repository**:
   ```bash
   git clone https://github.com/LtNITESNAKE/Dino_Game_ReinforcementLearning_JAVA.git
   ```

3. **Open in Processing**:
   - Launch Processing IDE
   - Open the `main.pde` file
   - Processing will automatically load all other .pde files

4. **Run the simulation**:
   - Click the "Run" button (play icon) or press Ctrl+R
   - Watch the evolution unfold in real-time

## Understanding the Visualization

### Game Display
- **Dinosaurs**: Green sprites represent individual agents
- **Obstacles**: Cacti (ground level) and birds (flying)
- **Ground**: Scrolling desert floor
- **Score**: Current generation's performance

### Neural Network Visualization
- **Nodes**: Circles represent neurons
  - Purple: Inactive neurons
  - Green: Active neurons
  - Size indicates activation strength
- **Connections**: Lines show neural pathways
  - Thickness represents connection strength
  - Color indicates positive (blue) or negative (red) weights

### Statistics Panel
- **Generation**: Current evolution cycle
- **Population**: Number of dinosaurs still alive
- **Score**: Current performance metrics
- **Best Score**: Highest score achieved this generation

## Game Mechanics

### Obstacle System
**Cactus Obstacles**:
- 6 different types with varying widths (28px to 142px)
- Ground-based positioning
- Requires jumping to avoid

**Bird Obstacles**:
- Flying at different heights
- Animated wing flapping
- Smooth hovering motion using sine waves
- Requires crouching to avoid

### Physics Implementation
**Jump Mechanics**:
- Initial upward velocity: 21 units
- Gravity: 0.9 units downward acceleration
- Creates realistic parabolic jump arc
- Speed adjustments for consistent timing

**Collision Detection**:
- Precise hitbox calculations with padding
- Special adjustments for bird obstacles
- Optimized for performance with early exit conditions

## Evolution Parameters

### Key Settings You Can Modify

**Population Parameters**:
```java
int DINOS_PER_GENERATION = 100;  // Population size
float ELITE_PERCENTAGE = 0.1;     // Top performers preserved
```

**Genetic Algorithm Settings**:
```java
float CROSSOVER_RATE = 0.7;       // Breeding probability
float MUTATION_RATE = 0.25;       // Weight mutation chance
float BIAS_MUTATION_RATE = 0.2;   // Bias mutation chance
```

**Neural Network Configuration**:
```java
int INPUT_NEURONS = 7;     // Sensory inputs
int HIDDEN_NEURONS = 7;    // Processing layer
int OUTPUT_NEURONS = 2;    // Action outputs
```

## Typical Learning Progression

**Generation 1-5**: Complete chaos
- Random jumping and crouching
- Very short survival times
- No recognizable patterns

**Generation 6-15**: Basic obstacle recognition
- Some dinosaurs start timing jumps better
- Occasional successful obstacle avoidance
- Survival times begin increasing

**Generation 16-30**: Skill development
- Consistent obstacle avoidance emerges
- Population average scores improve steadily
- Clear behavioral patterns develop

**Generation 31-50**: Optimization
- Fine-tuning of timing and decisions
- High-scoring individuals become common
- Population converges on effective strategies

**Generation 50+**: Mastery
- Consistent high performance
- Sophisticated decision-making
- Adaptation to game speed changes

## Educational Value

This project demonstrates several important computer science concepts:

**Artificial Intelligence**:
- How neural networks process information
- How genetic algorithms solve optimization problems
- The relationship between individual agents and population learning

**Evolutionary Computing**:
- Selection pressure and fitness landscapes
- The balance between exploration and exploitation
- How complex behaviors can emerge from simple rules

**Game Development**:
- Real-time physics simulation
- Collision detection algorithms
- Sprite animation and rendering

**Software Engineering**:
- Object-oriented design patterns
- Modular code organization
- Performance optimization techniques

## Customization Ideas

### Beginner Modifications
- Change population size to see how it affects learning speed
- Adjust mutation rates to observe evolution dynamics
- Modify obstacle spawn rates for different difficulty levels

### Intermediate Enhancements
- Add new obstacle types with different behaviors
- Implement different selection strategies (roulette wheel, rank-based)
- Create multiple environment types or difficulty modes

### Advanced Extensions
- Implement speciation (separate populations that evolve independently)
- Add memory to the neural networks (recurrent connections)
- Create competitive evolution where dinosaurs compete for resources

## Performance Considerations

The simulation is optimized for real-time performance:

**Rendering Optimizations**:
- Efficient sprite management with pre-loaded images
- Optimized collision detection with early exit conditions
- Minimal object creation during gameplay

**Memory Management**:
- Object pooling for frequently created/destroyed entities
- Efficient data structures for population management
- Careful resource cleanup between generations

**Computational Efficiency**:
- Fast matrix operations for neural network calculations
- Optimized genetic algorithm operations
- Balanced visualization updates

## Troubleshooting

**Common Issues**:

*Simulation runs slowly*:
- Reduce population size
- Simplify neural network visualization
- Close other applications

*Evolution seems stuck*:
- Increase mutation rate
- Verify fitness function is working correctly
- Check for population diversity issues

*Visualization problems*:
- Ensure Processing version compatibility
- Check that sprites.png is in the data folder
- Verify screen resolution compatibility

## Scientific Background

This implementation is based on several key research areas:

**Neuroevolution**: The combination of neural networks and evolutionary algorithms, pioneered by researchers like Kenneth Stanley and Risto Miikkulainen.

**Genetic Algorithms**: Developed by John Holland in the 1970s, inspired by Charles Darwin's theory of natural selection.

**Artificial Neural Networks**: Mathematical models inspired by biological neural networks, with roots in the 1940s work of McCulloch and Pitts.

The project serves as an excellent introduction to these concepts because it provides immediate visual feedback and demonstrates how complex behaviors can emerge from simple evolutionary rules.

## Contributing

This project is designed for educational exploration. Feel free to:

- Experiment with different parameters
- Add new features or obstacle types
- Improve the visualization system
- Optimize performance
- Share interesting evolutionary behaviors you discover

When contributing, please maintain the educational focus and ensure that modifications are well-documented with clear explanations of the underlying concepts.

## License

This project is created for educational purposes. Please respect the learning objectives and feel free to use it as a foundation for your own explorations in artificial intelligence and evolutionary computing.

---

*Watch evolution in action - from random chaos to skilled gameplay, all in the span of a few minutes!* 🦕🧬

## Further Reading

To deepen your understanding of the concepts demonstrated in this project:

- **"Evolutionary Computation: An Introduction"** by A.E. Eiben and J.E. Smith
- **"Neuroevolution: From Architecture to Learning"** by Dario Floreano and Claudio Mattiussi  
- **"Genetic Algorithms in Search, Optimization, and Machine Learning"** by David Goldberg
- **"Neural Networks and Deep Learning"** by Michael Nielsen (online book)

These resources will help you understand the theoretical foundations behind the practical implementation you see in this project.
