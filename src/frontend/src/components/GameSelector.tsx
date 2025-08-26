import React, { useState } from 'react'
import { Scissors, Hand, HandMetal, Coins, Zap, Target } from 'lucide-react'

interface UserProfile {
  id: any;
  username?: string;
  balance: number;
  createdAt: number;
  lastActive: number;
}

interface GameSelectorProps {
  userProfile: UserProfile;
  onBalanceUpdate: (newBalance: number) => void;
}

type GameType = 'rock-paper-scissors' | 'coin-flip'
type RPSChoice = 'rock' | 'paper' | 'scissors'
type CoinChoice = 'heads' | 'tails'

const GameSelector: React.FC<GameSelectorProps> = ({ userProfile, onBalanceUpdate }) => {
  const [selectedGame, setSelectedGame] = useState<GameType>('rock-paper-scissors')
  const [betAmount, setBetAmount] = useState('')
  const [playerChoice, setPlayerChoice] = useState<RPSChoice | CoinChoice>('rock')
  const [isPlaying, setIsPlaying] = useState(false)
  const [gameResult, setGameResult] = useState<string>('')
  const [showResult, setShowResult] = useState(false)

  const games = [
    {
      id: 'rock-paper-scissors',
      name: 'Rock Paper Scissors',
      description: 'Classic game with 2x payout on wins',
      icon: Scissors,
      color: 'from-blue-500 to-blue-600'
    },
    {
      id: 'coin-flip',
      name: 'Coin Flip',
      description: 'Simple 50/50 chance with 2x payout',
      icon: Coins,
      color: 'from-purple-500 to-purple-600'
    }
  ]

  const rpsChoices: { value: RPSChoice; label: string; icon: any }[] = [
    { value: 'rock', label: 'Rock', icon: HandMetal },
    { value: 'paper', label: 'Paper', icon: Hand },
    { value: 'scissors', label: 'Scissors', icon: Scissors }
  ]

  const coinChoices: { value: CoinChoice; label: string; icon: any }[] = [
    { value: 'heads', label: 'Heads', icon: Target },
    { value: 'tails', label: 'Tails', icon: Coins }
  ]

  const handleGameSelect = (gameType: GameType) => {
    setSelectedGame(gameType)
    setPlayerChoice(gameType === 'rock-paper-scissors' ? 'rock' : 'heads')
    setGameResult('')
    setShowResult(false)
  }

  const handlePlayGame = async () => {
    const amount = parseInt(betAmount)
    if (isNaN(amount) || amount <= 0 || amount > userProfile.balance) return

    setIsPlaying(true)
    setShowResult(false)

    try {
      // In a real implementation, you would call the game canister here
      // For now, we'll simulate the game
      await new Promise(resolve => setTimeout(resolve, 2000))

      const result = simulateGame(selectedGame, playerChoice, amount)
      setGameResult(result)
      setShowResult(true)

      // Update balance based on result
      if (result.includes('won')) {
        const winAmount = amount * 2 * 0.98 // 2x payout minus 2% house fee
        const newBalance = userProfile.balance + winAmount
        onBalanceUpdate(newBalance)
      } else if (result.includes('lost')) {
        const newBalance = userProfile.balance - amount
        onBalanceUpdate(newBalance)
      }
      // Draw returns the bet amount (no change in balance)

    } catch (error) {
      setGameResult('Game failed. Please try again.')
      setShowResult(true)
    } finally {
      setIsPlaying(false)
    }
  }

  const simulateGame = (gameType: GameType, choice: RPSChoice | CoinChoice, betAmount: number): string => {
    if (gameType === 'rock-paper-scissors') {
      const choices = ['rock', 'paper', 'scissors']
      const computerChoice = choices[Math.floor(Math.random() * 3)] as RPSChoice
      
      if (choice === computerChoice) {
        return `It's a draw! Computer chose ${computerChoice}. Your bet of ${betAmount} credits has been returned.`
      } else if (
        (choice === 'rock' && computerChoice === 'scissors') ||
        (choice === 'paper' && computerChoice === 'rock') ||
        (choice === 'scissors' && computerChoice === 'paper')
      ) {
        const winAmount = (betAmount * 2 * 0.98).toFixed(0)
        return `You won! Computer chose ${computerChoice}. You won ${winAmount} credits!`
      } else {
        return `You lost! Computer chose ${computerChoice}. You lost ${betAmount} credits.`
      }
    } else {
      // Coin flip
      const computerChoice = Math.random() < 0.5 ? 'heads' : 'tails'
      
      if (choice === computerChoice) {
        const winAmount = (betAmount * 2 * 0.98).toFixed(0)
        return `You won! Coin landed on ${computerChoice}. You won ${winAmount} credits!`
      } else {
        return `You lost! Coin landed on ${computerChoice}. You lost ${betAmount} credits.`
      }
    }
  }

  const getCurrentChoices = () => {
    return selectedGame === 'rock-paper-scissors' ? rpsChoices : coinChoices
  }

  return (
    <div className="grid gap-6">
      {/* Game Selection */}
      <div className="card">
        <h2 className="text-2xl mb-6">Choose Your Game</h2>
        <div className="grid grid-2 gap-4">
          {games.map((game) => {
            const Icon = game.icon
            const isSelected = selectedGame === game.id
            
            return (
              <div
                key={game.id}
                className={`game-card ${isSelected ? 'selected' : ''}`}
                onClick={() => handleGameSelect(game.id as GameType)}
              >
                <div className={`w-16 h-16 bg-gradient-to-r ${game.color} rounded-lg flex items-center justify-center mx-auto mb-4`}>
                  <Icon size={32} className="text-white" />
                </div>
                <h3 className="text-xl font-semibold mb-2">{game.name}</h3>
                <p className="text-gray-600 mb-4">{game.description}</p>
                <div className={`w-4 h-4 rounded-full mx-auto ${isSelected ? 'bg-blue-500' : 'bg-gray-300'}`}></div>
              </div>
            )
          })}
        </div>
      </div>

      {/* Game Interface */}
      <div className="card">
        <h3 className="text-xl mb-6">Place Your Bet</h3>
        
        <div className="grid grid-2 gap-6">
          {/* Bet Configuration */}
          <div>
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Bet Amount (Credits)
              </label>
              <input
                type="number"
                value={betAmount}
                onChange={(e) => setBetAmount(e.target.value)}
                placeholder="Enter bet amount"
                className="input"
                min="10"
                max={userProfile.balance}
              />
              <div className="text-sm text-gray-500 mt-1">
                Min: 10 | Max: {userProfile.balance.toLocaleString()}
              </div>
            </div>

            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Your Choice
              </label>
              <div className="grid grid-3 gap-2">
                {getCurrentChoices().map((choice) => {
                  const Icon = choice.icon
                  const isSelected = playerChoice === choice.value
                  
                  return (
                    <button
                      key={choice.value}
                      onClick={() => setPlayerChoice(choice.value)}
                      className={`p-3 rounded-lg border-2 transition-all ${
                        isSelected
                          ? 'border-blue-500 bg-blue-50 text-blue-700'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <Icon size={20} className="mx-auto mb-1" />
                      <div className="text-sm font-medium">{choice.label}</div>
                    </button>
                  )
                })}
              </div>
            </div>

            <button
              onClick={handlePlayGame}
              disabled={isPlaying || !betAmount || parseInt(betAmount) > userProfile.balance}
              className="btn w-full text-lg py-3"
            >
              {isPlaying ? (
                <div className="flex items-center gap-2">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                  Playing...
                </div>
              ) : (
                <div className="flex items-center gap-2">
                  <Zap size={20} />
                  Place Bet
                </div>
              )}
            </button>
          </div>

          {/* Game Info */}
          <div>
            <div className="bg-gray-50 rounded-lg p-4 mb-4">
              <h4 className="font-semibold mb-2">Game Rules</h4>
              {selectedGame === 'rock-paper-scissors' ? (
                <ul className="text-sm text-gray-600 space-y-1">
                  <li>• Rock beats Scissors</li>
                  <li>• Paper beats Rock</li>
                  <li>• Scissors beats Paper</li>
                  <li>• Draw returns your bet</li>
                  <li>• Win pays 2x (minus 2% fee)</li>
                </ul>
              ) : (
                <ul className="text-sm text-gray-600 space-y-1">
                  <li>• Choose Heads or Tails</li>
                  <li>• 50/50 chance to win</li>
                  <li>• Win pays 2x (minus 2% fee)</li>
                  <li>• Lose forfeits your bet</li>
                </ul>
              )}
            </div>

            <div className="bg-blue-50 rounded-lg p-4">
              <h4 className="font-semibold text-blue-800 mb-2">House Edge</h4>
              <p className="text-sm text-blue-700">
                A 2% house fee is applied to all winning bets to maintain the platform.
              </p>
            </div>
          </div>
        </div>

        {/* Game Result */}
        {showResult && (
          <div className="mt-6 p-4 bg-gray-50 rounded-lg">
            <h4 className="font-semibold mb-2">Game Result</h4>
            <p className="text-gray-700">{gameResult}</p>
          </div>
        )}
      </div>

      {/* Game History Placeholder */}
      <div className="card">
        <h3 className="text-xl mb-4">Recent Games</h3>
        <div className="text-center py-8 text-gray-500">
          <p>No recent games</p>
          <p className="text-sm">Start playing to see your game history here!</p>
        </div>
      </div>
    </div>
  )
}

export default GameSelector 