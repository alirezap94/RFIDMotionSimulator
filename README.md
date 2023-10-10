# RFID Communication Simulation

## Description

This repository contains MATLAB scripts for simulating RFID communication, accounting for various realistic parameters and scenarios. It investigates the transmission of RFID signals through a channel, providing an option to assess environmental impacts and exploring the effects of a person's presence on signal propagation.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Scripts Description](#scripts-description)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Prerequisites
Ensure you have MATLAB installed to run the simulation scripts.

### Clone the Repository
git clone https://github.com/alirezap94/RFIDMotionSimulator.git

Navigate to the project directory to access the scripts.

## Usage
To utilize the simulation:
Execute **`main.m`** to observe the simulation results.

## Scripts Description

- **`init_RFID.m`** - Initializes the parameters related to RFID communication and channel.
- **`transmit_RFID.m`** - Generates a packet of binary data and modulates it using BPSK.
- **`channel_RFID.m`** - Simulates the propagation of the signal through a Rayleigh fading channel and introduces noise.
- **Main Script** - Manages the overall simulation, running transmissions through the channel, and visualizes the signal observations.

## Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
Distributed under the MIT License. See `LICENSE` for more information.
