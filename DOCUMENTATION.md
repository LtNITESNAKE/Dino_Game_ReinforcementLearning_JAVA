# Dino Game AI Documentation

This document provides a detailed explanation of the project's code structure, implementation details, and core concepts.

## Table of Contents
1. [Code Architecture](#code-architecture)
2. [Core Components](#core-components)
3. [Neural Network Implementation](#neural-network-implementation)
4. [Genetic Algorithm Details](#genetic-algorithm-details)
5. [Game Mechanics](#game-mechanics)
6. [Visualization System](#visualization-system)

## Code Architecture

### File Structure and Purpose

1. **main.pde**
   - Program entry point
   - Setup and main game loop
   - Global variables and sprite management
   - Core UI elements and color scheme
   ```processing
   void setup() {
     // Initialize game window and resources
   }
   void draw() {
     // Main game loop with state management
   }
   ```

2. **Simulation.pde**
   - Evolution logic and generation management
   - Obstacle spawning and difficulty scaling
   - Score tracking and statistics
   - Generation transition effects
   ```processing
   class Simulation {
     // Manages population of dinosaurs
     // Handles evolution between generations
     // Controls game difficulty and progression
   }
   ```

3. **Dino.pde**
   - Dinosaur agent behavior and physics
   - Neural network integration
   - Movement controls (jump/crouch)
   ```processing
   class Dino extends GameObject {
     // Individual dinosaur agent implementation
     // Neural network decision processing
     // Physics and movement controls
   }
   ```

4. **Enemy.pde**
   - Obstacle types and behavior
   - Collision detection
   - Movement patterns
   ```processing
   abstract class Enemy extends GameObject {
     // Base class for obstacles
     class Cactus extends Enemy { }
     class Bird extends Enemy { }
   }
   ```

5. **Brain.pde**
   - Neural network architecture
   - Forward propagation
   - Network visualization
   ```processing
   class Brain {
     // Neural network implementation
     // Input processing and decision making
     // Network visualization methods
   }
   ```

6. **Genome.pde**
   - Genetic encoding
   - Mutation and crossover operations
   - Evolution parameters
   ```processing
   class Genome {
     // Genetic representation
     // Evolution operators
     // Parameter management
   }
   ```

## Core Components

### Neural Network Design

The neural network consists of:
- **Input Layer (7 neurons)**
  1. Distance to next obstacle
  2. Obstacle x position
  3. Obstacle y position
  4. Obstacle width
  5. Obstacle height
  6. Dinosaur y position
  7. Current game speed

- **Hidden Layer (7 neurons)**
  - Uses tanh activation function
  - Fully connected to input and output layers
  - Adaptive bias values

- **Output Layer (2 neurons)**
  1. Jump decision (threshold: 0.48)
  2. Crouch decision (threshold: 0.55)

### Genetic Algorithm Implementation

#### Selection Process
1. **Elite Selection (10%)**
   - Top performers preserved unchanged
   - Guarantees preservation of best traits

2. **Tournament Selection**
   - Tournament size: 3 individuals
   - Selects parents for breeding
   - Balances exploration and exploitation

#### Evolution Operators
1. **Crossover**
   - 70% chance of genetic mixing
   - Weighted averaging of neural weights
   - Preserves successful neural pathways

2. **Mutation**
   - Adaptive mutation rates
   - Controlled weight adjustments
   - Bias value mutations

## Game Mechanics

### Collision Detection
```processing
boolean is_collisioning_with(GameObject anObject) {
    // Precise hitbox calculations
    // Adjustments for different obstacle types
    // Performance optimized checks
}
```

### Obstacle Generation
1. **Cactus Obstacles**
   - 6 different types
   - Variable sizes
   - Ground-based positioning

2. **Bird Obstacles**
   - 3 height levels
   - Animated movement
   - Smooth hover effect

### Physics System
1. **Jump Mechanics**
   - Initial velocity: 21
   - Gravity: 0.9
   - Speed-based adjustments

2. **Movement System**
   - Constant speed design
   - Smooth acceleration
   - Collision response

## Visualization System

### Neural Network Display
- Real-time weight visualization
- Active neuron highlighting
- Connection strength indication

### UI Elements
1. **Score Display**
   - Current score
   - Generation number
   - Population statistics

2. **Generation Transitions**
   - Smooth fade effects
   - Statistical summaries
   - Progress indicators

3. **Performance Metrics**
   - Average score
   - High score
   - Population status

## Performance Optimization

### Rendering Optimizations
1. **Sprite Management**
   - Pre-loaded sprites
   - Efficient rendering
   - Memory management

2. **Collision Detection**
   - Optimized hitbox calculations
   - Early exit conditions
   - Spatial partitioning

### Memory Management
1. **Object Pooling**
   - Reuse of game objects
   - Minimized garbage collection
   - Efficient resource usage

2. **Data Structures**
   - Optimized collections
   - Efficient lookups
   - Minimal object creation

## Future Improvements

1. **Enhanced Learning**
   - Dynamic neural architecture
   - Advanced genetic operators
   - Improved selection methods

2. **Game Features**
   - Additional obstacle types
   - Dynamic environments
   - Difficulty modes

3. **Visualization**
   - Advanced analytics
   - Learning progress graphs
   - Detailed statistics

## Contributing Guidelines

1. **Code Style**
   - Follow existing patterns
   - Document new features
   - Maintain performance focus

2. **Testing**
   - Verify evolution stability
   - Check performance impact
   - Ensure visualization clarity

3. **Optimization**
   - Profile before optimizing
   - Document performance changes
   - Maintain readability
