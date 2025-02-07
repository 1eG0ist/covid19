# COVID-19 Simulation in Flutter

## Overview

This Flutter application simulates the spread of COVID-19 in a population. It visualizes how individuals move around and infect each other based on certain parameters like infection chance and speed. The simulation is built using Dart and Flutter, providing an interactive way to observe the dynamics of disease spread.

## Features

- **Dynamic Simulation**: Individuals move around randomly within a defined space.
- **Infection Spread**: Infected individuals can infect others based on proximity and infection chance.
- **Customizable Parameters**: Adjust total population, initial infected count, infection chance, and movement speed.
- **Real-time Visualization**: Visual representation of infected and non-infected individuals.
- **Timer**: Track the duration of the simulation.

## Getting Started

### Prerequisites

- Flutter SDK installed on your machine.
- Dart programming language knowledge.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/covid19-simulation.git
   cd covid19-simulation
   ```

2. **Get Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

## Code Structure

### Models

- **Person**: Represents an individual in the simulation.
    - Properties: Position (`x`, `y`), infection status (`isInfected`), and movement speed (`speed`).
    - Methods: `move` (updates position), `checkCollision` (checks for infection spread).

- **SimulationModel**: Manages the simulation logic.
    - Properties: List of `Person` objects, infection parameters, and simulation state.
    - Methods: `start` (initializes the simulation), `update` (updates the state of the simulation).

### Screens

- **SimulationScreen**: Main screen displaying the simulation.
    - Contains UI elements to input simulation parameters and start the simulation.
    - Uses `AnimationController` to animate the movement of individuals.

### Painters

- **SimulationPainter**: Custom painter to draw individuals on the screen.
    - Draws circles to represent individuals, with different colors for infected and non-infected states.

## Usage

1. **Input Parameters**:
    - Total People: Total number of individuals in the simulation.
    - Initial Infected: Number of initially infected individuals.
    - Infection Chance: Probability of infection upon collision.
    - Speed: Movement speed of individuals.

2. **Start Simulation**: Click the "Start" button to begin the simulation.

3. **Observe**: Watch as individuals move around and the infection spreads. The timer displays the elapsed time.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE] file for details.

## Acknowledgments

- Inspired by the need to visualize and understand the spread of infectious diseases.
- Built with Flutter and Dart for cross-platform compatibility.

---

This README provides a comprehensive overview of the COVID-19 simulation project, its features, and how to get started. Customize it further based on your specific needs and additional features you might add in the future.