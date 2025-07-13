# Evolutionary Reinforcement Learning for Dino Game

<img src="https://i.imgur.com/5PfGc6h.png" />

## Introduction

Welcome to the Evolutionary Reinforcement Learning for Dino Game project! This project implements a genetic algorithm combined with neural networks to teach AI agents how to play the popular Chrome Dinosaur Game. The AI learns and evolves through generations, developing increasingly sophisticated strategies to avoid obstacles and achieve higher scores.

## Features

- 🧬 **Genetic Algorithm**: Implements natural selection and evolution through generations
- 🧠 **Neural Network**: Custom-built neural network for decision making
- 🎮 **Game Physics**: Accurate recreation of Chrome's dinosaur game mechanics
- 📊 **Real-time Visualization**: Neural network activity and decision-making process
- 📈 **Performance Tracking**: Generation statistics and evolutionary progress
- 🎨 **Modern UI**: Clean, projector-friendly interface with smooth transitions

## Key Components

- **Neural Network Architecture**
  - 7 Input neurons (distance, position, speed, etc.)
  - 7 Hidden layer neurons with optimized weights
  - 2 Output neurons (jump and crouch decisions)

- **Genetic Evolution**
  - Population size: 100 dinosaurs per generation
  - Elite selection preservation (top 10%)
  - Tournament selection for breeding
  - Adaptive mutation rates
  - Crossover breeding mechanism

- **Game Mechanics**
  - Dynamic obstacle generation
  - Precise collision detection
  - Bird and cactus obstacles
  - Speed-based difficulty scaling

## Getting Started

### Prerequisites
1. Download and install [Processing](https://processing.org/)
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dino-reinforcement-learning.git
   ```

### Running the Simulation
1. Open the project in Processing
2. Click the "Run" button or press Ctrl+R
3. Watch the AI evolve through generations!

## How It Works

The simulation follows these key steps:

1. **Initialization**
   - Creates a population of dinosaurs with random neural networks
   - Sets up the game environment with initial parameters

2. **Game Loop**
   - Updates dinosaur positions and states
   - Generates and moves obstacles
   - Processes neural network inputs and decisions
   - Handles collisions and scoring

3. **Evolution**
   - Evaluates fitness based on survival time and score
   - Selects best performers for breeding
   - Applies genetic crossover and mutation
   - Creates new generation with improved traits

4. **Visualization**
   - Displays game state and dinosaur actions
   - Shows neural network activity in real-time
   - Presents generation statistics and progress
   - Provides transition screens between generations

## Code Structure

See [DOCUMENTATION.md](DOCUMENTATION.md) for detailed code explanations and architecture.

## Project Structure
```
├── main.pde           # Main game loop and setup
├── Simulation.pde     # Evolution and game logic
├── Dino.pde          # Dinosaur agent behavior
├── Enemy.pde         # Obstacle implementation
├── Brain.pde         # Neural network logic
├── Genome.pde        # Genetic algorithm implementation
├── GameObject.pde    # Base game object class
└── LinearAlgebra.pde # Math utility functions
```

## Why Processing?

This project was intentionally built from scratch in Processing, avoiding popular ML libraries like TensorFlow. This approach provided:

1. **Deep Understanding**: Building every component manually enabled a thorough understanding of the underlying algorithms
2. **Educational Value**: Clear visualization of AI concepts in action
3. **Performance**: Lightweight implementation suitable for real-time simulation
4. **Accessibility**: Easy to run and modify without complex dependencies

## Contributing

Contributions are welcome! Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by Google Chrome's Dinosaur Game
- Built with Processing
- Neural Network architecture inspired by NEAT algorithm
- Special thanks to the Processing community

