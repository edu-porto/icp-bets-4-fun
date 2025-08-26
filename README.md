# ICP Bets - Decentralized Betting Platform

A complete decentralized betting platform built on the Internet Computer (ICP) using Motoko and React. The platform features Rock-Paper-Scissors and Coin Flip games with provably fair randomness, user authentication via Internet Identity, and a DAO treasury system.

## 🏗️ Architecture

The platform consists of 4 canisters:

1. **Auth Canister** (`src/auth/main.mo`) - User authentication and balance management
2. **Game Canister** (`src/game/main.mo`) - Game logic with provably fair randomness
3. **Treasury Canister** (`src/treasury/main.mo`) - DAO treasury and transaction management
4. **Frontend Canister** (`src/frontend/`) - React-based user interface

## ✨ Features

- **Internet Identity Authentication** - Secure, privacy-preserving login
- **Provably Fair Games** - Rock-Paper-Scissors and Coin Flip with cryptographic randomness
- **DAO Treasury** - Community-governed fund management with 2% house fee
- **Real-time Betting** - Instant game results and balance updates
- **Responsive UI** - Modern, mobile-friendly interface
- **Future-Ready** - Architecture supports governance token distribution

## 🚀 Quick Start

### Prerequisites

- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install/) (version 0.15.0 or later)
- [Node.js](https://nodejs.org/) (version 16 or later)
- [Internet Identity](https://internetcomputer.org/docs/current/developer-docs/integrations/internet-identity/) (for authentication)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd icp-bets-4-fun
   ```

2. **Install frontend dependencies**
   ```bash
   cd src/frontend
   npm install
   cd ../..
   ```

3. **Start local Internet Computer**
   ```bash
   dfx start --background
   ```

4. **Deploy canisters**
   ```bash
   dfx deploy
   ```

5. **Build and deploy frontend**
   ```bash
   cd src/frontend
   npm run build
   cd ../..
   dfx deploy frontend
   ```

6. **Open the application**
   ```bash
   dfx canister open frontend
   ```

## 🎮 How to Play

### Getting Started
1. **Sign In** - Use Internet Identity to authenticate
2. **Get Credits** - Start with 1000 free credits
3. **Choose Game** - Select Rock-Paper-Scissors or Coin Flip
4. **Place Bet** - Enter bet amount and make your choice
5. **Get Results** - Instant, provably fair results

### Game Rules

#### Rock-Paper-Scissors
- **Win**: 2x payout (minus 2% house fee)
- **Lose**: Forfeit bet amount
- **Draw**: Bet amount returned

#### Coin Flip
- **Win**: 2x payout (minus 2% house fee)
- **Lose**: Forfeit bet amount

### Betting Limits
- **Minimum Bet**: 10 credits
- **Maximum Bet**: 10,000 credits
- **House Fee**: 2% on winning bets

## 🔧 Development

### Project Structure
```
icp-bets-4-fun/
├── dfx.json                 # DFX configuration
├── src/
│   ├── auth/               # Authentication canister
│   │   └── main.mo
│   ├── game/               # Game logic canister
│   │   └── main.mo
│   ├── treasury/           # Treasury/DAO canister
│   │   └── main.mo
│   └── frontend/           # React frontend
│       ├── src/
│       │   ├── components/ # React components
│       │   ├── App.tsx     # Main app component
│       │   └── main.tsx    # Entry point
│       ├── package.json    # Frontend dependencies
│       └── vite.config.ts  # Build configuration
└── README.md
```

### Canister Development

#### Auth Canister
- User profile management
- Balance tracking
- Internet Identity integration

#### Game Canister
- Game state management
- Provably fair randomness
- Result calculation

#### Treasury Canister
- Transaction recording
- House fee collection
- DAO governance preparation

### Frontend Development

The React frontend uses:
- **Vite** for fast development and building
- **TypeScript** for type safety
- **Tailwind CSS** for styling
- **Lucide React** for icons

#### Development Commands
```bash
cd src/frontend
npm run dev      # Start development server
npm run build    # Build for production
npm run preview  # Preview production build
```

## 🌐 Deployment

### Local Development
```bash
dfx start --background
dfx deploy
```

### Mainnet Deployment
```bash
dfx deploy --network ic
```

### Environment Variables
Set the following for mainnet deployment:
```bash
export INTERNET_IDENTITY_CANISTER_ID="rdmx6-jaaaa-aaaaa-aaadq-cai"
```

## 🔒 Security Features

- **Provably Fair Randomness** - Cryptographic hash-based game results
- **Internet Identity** - Secure, privacy-preserving authentication
- **Canister Isolation** - Separate concerns for security
- **Transaction Recording** - All bets and results recorded on-chain

## 🚧 Future Enhancements

- **Governance Token** - DAO voting and platform governance
- **Additional Games** - Dice, roulette, and more
- **Tournaments** - Competitive betting events
- **Mobile App** - Native mobile application
- **API Integration** - Third-party game integration

## 🐛 Troubleshooting

### Common Issues

1. **DFX not found**
   ```bash
   sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
   ```

2. **Canister deployment fails**
   ```bash
   dfx stop
   dfx start --clean --background
   dfx deploy
   ```

3. **Frontend build errors**
   ```bash
   cd src/frontend
   rm -rf node_modules package-lock.json
   npm install
   npm run build
   ```

4. **Authentication issues**
   - Ensure Internet Identity is running locally
   - Check canister IDs in dfx.json
   - Verify network configuration

### Debug Commands

```bash
# Check canister status
dfx canister status auth
dfx canister status game
dfx canister status treasury
dfx canister status frontend

# View canister logs
dfx canister call auth getTotalUsers
dfx canister call game getTotalGames
dfx canister call treasury getTreasuryBalance

# Check network status
dfx ping
dfx identity whoami
```

## 📚 Resources

- [Internet Computer Documentation](https://internetcomputer.org/docs)
- [Motoko Language Guide](https://internetcomputer.org/docs/current/developer-docs/build/languages/motoko/)
- [DFX Reference](https://internetcomputer.org/docs/current/references/cli-reference/)
- [Internet Identity](https://internetcomputer.org/docs/current/developer-docs/integrations/internet-identity/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This is a demonstration project for educational purposes. Please ensure compliance with local gambling regulations before deploying in production environments.

---

**Built with ❤️ for the Internet Computer ecosystem** 
