import React, { useState } from 'react'
import { RefreshCw, TrendingUp, TrendingDown, DollarSign, Activity, Users, BarChart3 } from 'lucide-react'

interface TreasuryStatsData {
  totalBalance: number;
  totalBets: number;
  totalWagered: number;
  totalWon: number;
  totalLost: number;
  totalHouseFees: number;
  totalDeposits: number;
  totalWithdrawals: number;
}

interface TreasuryStatsProps {
  stats: TreasuryStatsData | null;
  onRefresh: () => void;
}

const TreasuryStats: React.FC<TreasuryStatsProps> = ({ stats, onRefresh }) => {
  const [isRefreshing, setIsRefreshing] = useState(false)

  const handleRefresh = async () => {
    setIsRefreshing(true)
    try {
      await onRefresh()
    } finally {
      setIsRefreshing(false)
    }
  }

  if (!stats) {
    return (
      <div className="card text-center">
        <div className="text-xl">Loading treasury statistics...</div>
      </div>
    )
  }

  const statsItems = [
    {
      icon: DollarSign,
      label: 'Total Balance',
      value: stats.totalBalance.toLocaleString(),
      color: 'text-green-600',
      bgColor: 'bg-green-50'
    },
    {
      icon: Activity,
      label: 'Total Bets',
      value: stats.totalBets.toLocaleString(),
      color: 'text-blue-600',
      bgColor: 'bg-blue-50'
    },
    {
      icon: TrendingUp,
      label: 'Total Wagered',
      value: stats.totalWagered.toLocaleString(),
      color: 'text-purple-600',
      bgColor: 'bg-purple-50'
    },
    {
      icon: TrendingDown,
      label: 'Total Won',
      value: stats.totalWon.toLocaleString(),
      color: 'text-green-600',
      bgColor: 'bg-green-50'
    },
    {
      icon: BarChart3,
      label: 'Total Lost',
      value: stats.totalLost.toLocaleString(),
      color: 'text-red-600',
      bgColor: 'bg-red-50'
    },
    {
      icon: Users,
      label: 'House Fees',
      value: stats.totalHouseFees.toLocaleString(),
      color: 'text-orange-600',
      bgColor: 'bg-orange-50'
    }
  ]

  const transactionItems = [
    {
      label: 'Total Deposits',
      value: stats.totalDeposits.toLocaleString(),
      color: 'text-green-600'
    },
    {
      label: 'Total Withdrawals',
      value: stats.totalWithdrawals.toLocaleString(),
      color: 'text-red-600'
    }
  ]

  const calculateMetrics = () => {
    const winRate = stats.totalBets > 0 ? (stats.totalWon / stats.totalWagered) * 100 : 0
    const houseEdge = stats.totalWagered > 0 ? (stats.totalHouseFees / stats.totalWagered) * 100 : 0
    const avgBetSize = stats.totalBets > 0 ? stats.totalWagered / stats.totalBets : 0

    return {
      winRate: winRate.toFixed(2),
      houseEdge: houseEdge.toFixed(2),
      avgBetSize: avgBetSize.toFixed(0)
    }
  }

  const metrics = calculateMetrics()

  return (
    <div className="grid gap-6">
      {/* Header */}
      <div className="card">
        <div className="flex justify-between items-center">
          <div>
            <h2 className="text-2xl mb-2">DAO Treasury</h2>
            <p className="text-gray-600">
              Platform statistics and treasury management
            </p>
          </div>
          
          <button
            onClick={handleRefresh}
            disabled={isRefreshing}
            className="btn flex items-center gap-2"
          >
            <RefreshCw size={18} className={isRefreshing ? 'animate-spin' : ''} />
            Refresh
          </button>
        </div>
      </div>

      {/* Main Stats Grid */}
      <div className="card">
        <h3 className="text-xl mb-6">Treasury Overview</h3>
        <div className="stats-grid">
          {statsItems.map((item, index) => {
            const Icon = item.icon
            
            return (
              <div key={index} className="stat-item">
                <div className={`w-12 h-12 ${item.bgColor} rounded-lg flex items-center justify-center mx-auto mb-3`}>
                  <Icon size={24} className={item.color} />
                </div>
                <div className="stat-value">{item.value}</div>
                <div className="stat-label">{item.label}</div>
              </div>
            )
          })}
        </div>
      </div>

      {/* Key Metrics */}
      <div className="card">
        <h3 className="text-xl mb-6">Key Metrics</h3>
        <div className="grid grid-3 gap-6">
          <div className="text-center p-6 bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg">
            <div className="text-3xl font-bold text-blue-600 mb-2">
              {metrics.winRate}%
            </div>
            <div className="text-sm text-blue-700 font-medium">
              Player Win Rate
            </div>
            <div className="text-xs text-blue-600 mt-1">
              Based on total wagered vs won
            </div>
          </div>
          
          <div className="text-center p-6 bg-gradient-to-br from-green-50 to-green-100 rounded-lg">
            <div className="text-3xl font-bold text-green-600 mb-2">
              {metrics.houseEdge}%
            </div>
            <div className="text-sm text-green-700 font-medium">
              House Edge
            </div>
            <div className="text-xs text-green-600 mt-1">
              Platform fee percentage
            </div>
          </div>
          
          <div className="text-center p-6 bg-gradient-to-br from-purple-50 to-purple-100 rounded-lg">
            <div className="text-3xl font-bold text-purple-600 mb-2">
              {metrics.avgBetSize}
            </div>
            <div className="text-sm text-purple-700 font-medium">
              Average Bet Size
            </div>
            <div className="text-xs text-purple-600 mt-1">
              Credits per bet
            </div>
          </div>
        </div>
      </div>

      {/* Transaction Summary */}
      <div className="card">
        <h3 className="text-xl mb-6">Transaction Summary</h3>
        <div className="grid grid-2 gap-6">
          {transactionItems.map((item, index) => (
            <div key={index} className="p-4 bg-gray-50 rounded-lg">
              <div className="text-2xl font-bold mb-1" style={{ color: item.color }}>
                {item.value}
              </div>
              <div className="text-gray-600">{item.label}</div>
            </div>
          ))}
        </div>
      </div>

      {/* DAO Governance Info */}
      <div className="card">
        <h3 className="text-xl mb-6">DAO Governance</h3>
        <div className="grid gap-4">
          <div className="p-4 bg-blue-50 rounded-lg">
            <h4 className="font-semibold text-blue-800 mb-2">Platform Parameters</h4>
            <div className="grid grid-2 gap-4 text-sm">
              <div>
                <span className="text-gray-600">House Fee:</span>
                <span className="font-medium ml-2">2%</span>
              </div>
              <div>
                <span className="text-gray-600">Min Bet:</span>
                <span className="font-medium ml-2">10 credits</span>
              </div>
              <div>
                <span className="text-gray-600">Max Bet:</span>
                <span className="font-medium ml-2">10,000 credits</span>
              </div>
              <div>
                <span className="text-gray-600">Win Multiplier:</span>
                <span className="font-medium ml-2">2x</span>
              </div>
            </div>
          </div>
          
          <div className="p-4 bg-green-50 rounded-lg">
            <h4 className="font-semibold text-green-800 mb-2">Future Governance Features</h4>
            <ul className="text-sm text-green-700 space-y-1">
              <li>• Community voting on fee changes</li>
              <li>• Bet limit adjustments</li>
              <li>• New game proposals</li>
              <li>• Treasury allocation decisions</li>
              <li>• Governance token distribution</li>
            </ul>
          </div>
        </div>
      </div>

      {/* Recent Transactions Placeholder */}
      <div className="card">
        <h3 className="text-xl mb-4">Recent Transactions</h3>
        <div className="text-center py-8 text-gray-500">
          <Activity size={48} className="mx-auto mb-4 opacity-50" />
          <p>Transaction history will appear here</p>
          <p className="text-sm">All platform transactions are recorded on-chain</p>
        </div>
      </div>
    </div>
  )
}

export default TreasuryStats 