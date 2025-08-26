import React, { useState } from 'react'
import { Plus, Minus, Gamepad2, TrendingUp, Award, Clock } from 'lucide-react'

interface UserProfile {
  id: any;
  username?: string;
  balance: number;
  createdAt: number;
  lastActive: number;
}

interface DashboardProps {
  userProfile: UserProfile;
  onBalanceUpdate: (newBalance: number) => void;
}

const Dashboard: React.FC<DashboardProps> = ({ userProfile, onBalanceUpdate }) => {
  const [depositAmount, setDepositAmount] = useState('')
  const [withdrawAmount, setWithdrawAmount] = useState('')
  const [isProcessing, setIsProcessing] = useState(false)

  const handleDeposit = async () => {
    const amount = parseInt(depositAmount)
    if (isNaN(amount) || amount <= 0) return

    setIsProcessing(true)
    try {
      // In a real implementation, you would call the treasury canister here
      // For now, we'll simulate the deposit
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      const newBalance = userProfile.balance + amount
      onBalanceUpdate(newBalance)
      setDepositAmount('')
      
      // Show success message
      alert(`Successfully deposited ${amount} credits!`)
    } catch (error) {
      alert('Deposit failed. Please try again.')
    } finally {
      setIsProcessing(false)
    }
  }

  const handleWithdraw = async () => {
    const amount = parseInt(withdrawAmount)
    if (isNaN(amount) || amount <= 0 || amount > userProfile.balance) return

    setIsProcessing(true)
    try {
      // In a real implementation, you would call the treasury canister here
      // For now, we'll simulate the withdrawal
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      const newBalance = userProfile.balance - amount
      onBalanceUpdate(newBalance)
      setWithdrawAmount('')
      
      // Show success message
      alert(`Successfully withdrawn ${amount} credits!`)
    } catch (error) {
      alert('Withdrawal failed. Please try again.')
    } finally {
      setIsProcessing(false)
    }
  }

  const quickActions = [
    {
      icon: Gamepad2,
      title: 'Play Games',
      description: 'Place bets on Rock Paper Scissors or Coin Flip',
      action: 'Start Playing',
      color: 'from-blue-500 to-blue-600'
    },
    {
      icon: TrendingUp,
      title: 'View Stats',
      description: 'Check your betting history and performance',
      action: 'View Stats',
      color: 'from-green-500 to-green-600'
    },
    {
      icon: Award,
      title: 'Leaderboard',
      description: 'See how you rank against other players',
      action: 'View Rankings',
      color: 'from-purple-500 to-purple-600'
    }
  ]

  return (
    <div className="grid gap-6">
      {/* Welcome Section */}
      <div className="card">
        <div className="text-center">
          <h2 className="text-2xl mb-2">Welcome back, {userProfile.username || 'Player'}!</h2>
          <p className="text-gray-600">Ready to place some bets?</p>
        </div>
      </div>

      {/* Balance and Actions */}
      <div className="grid grid-2 gap-6">
        {/* Current Balance */}
        <div className="card">
          <h3 className="text-xl mb-4">Current Balance</h3>
          <div className="text-3xl font-bold text-green-600 mb-6">
            {userProfile.balance.toLocaleString()} Credits
          </div>
          
          <div className="grid gap-3">
            <div className="flex gap-2">
              <input
                type="number"
                value={depositAmount}
                onChange={(e) => setDepositAmount(e.target.value)}
                placeholder="Amount to deposit"
                className="input flex-1"
                min="1"
              />
              <button
                onClick={handleDeposit}
                disabled={isProcessing || !depositAmount}
                className="btn flex items-center gap-2"
              >
                <Plus size={16} />
                Deposit
              </button>
            </div>
            
            <div className="flex gap-2">
              <input
                type="number"
                value={withdrawAmount}
                onChange={(e) => setWithdrawAmount(e.target.value)}
                placeholder="Amount to withdraw"
                className="input flex-1"
                min="1"
                max={userProfile.balance}
              />
              <button
                onClick={handleWithdraw}
                disabled={isProcessing || !withdrawAmount || parseInt(withdrawAmount) > userProfile.balance}
                className="btn flex items-center gap-2"
              >
                <Minus size={16} />
                Withdraw
              </button>
            </div>
          </div>
        </div>

        {/* Quick Stats */}
        <div className="card">
          <h3 className="text-xl mb-4">Quick Stats</h3>
          <div className="grid gap-4">
            <div className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
              <span className="text-gray-600">Member Since</span>
              <span className="font-semibold">
                {new Date(userProfile.createdAt).toLocaleDateString()}
              </span>
            </div>
            <div className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
              <span className="text-gray-600">Last Active</span>
              <span className="font-semibold">
                {new Date(userProfile.lastActive).toLocaleDateString()}
              </span>
            </div>
            <div className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
              <span className="text-gray-600">Account Status</span>
              <span className="badge badge-success">Active</span>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="card">
        <h3 className="text-xl mb-6">Quick Actions</h3>
        <div className="grid grid-3 gap-4">
          {quickActions.map((action, index) => {
            const Icon = action.icon
            
            return (
              <div key={index} className="game-card">
                <div className={`w-12 h-12 bg-gradient-to-r ${action.color} rounded-lg flex items-center justify-center mx-auto mb-4`}>
                  <Icon size={24} className="text-white" />
                </div>
                <h4 className="font-semibold mb-2">{action.title}</h4>
                <p className="text-sm text-gray-600 mb-4">{action.description}</p>
                <button className="btn w-full">
                  {action.action}
                </button>
              </div>
            )
          })}
        </div>
      </div>

      {/* Recent Activity */}
      <div className="card">
        <h3 className="text-xl mb-4">Recent Activity</h3>
        <div className="text-center py-8 text-gray-500">
          <Clock size={48} className="mx-auto mb-4 opacity-50" />
          <p>No recent activity</p>
          <p className="text-sm">Start playing games to see your activity here!</p>
        </div>
      </div>
    </div>
  )
}

export default Dashboard 