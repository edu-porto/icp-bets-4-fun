import React from 'react'
import { Shield, Zap, Users, TrendingUp } from 'lucide-react'

interface LoginProps {
  onLogin: () => void;
}

const Login: React.FC<LoginProps> = ({ onLogin }) => {
  const features = [
    {
      icon: Shield,
      title: 'Secure & Decentralized',
      description: 'Built on Internet Computer with provably fair games'
    },
    {
      icon: Zap,
      title: 'Instant Results',
      description: 'Fast gameplay with real-time payouts'
    },
    {
      icon: Users,
      title: 'Community Driven',
      description: 'DAO governance for platform decisions'
    },
    {
      icon: TrendingUp,
      title: 'Transparent',
      description: 'All transactions visible on-chain'
    }
  ]

  return (
    <div className="grid grid-2 gap-6">
      <div className="card">
        <div className="text-center mb-6">
          <h2 className="text-2xl mb-4">Welcome to ICP Bets</h2>
          <p className="text-gray-600 mb-6">
            The decentralized betting platform on Internet Computer
          </p>
          
          <button
            onClick={onLogin}
            className="btn text-lg px-8 py-4"
          >
            Sign in with Internet Identity
          </button>
          
          <p className="text-sm text-gray-500 mt-4">
            No registration required • Secure authentication • Privacy first
          </p>
        </div>
      </div>

      <div className="card">
        <h3 className="text-xl mb-6">Platform Features</h3>
        
        <div className="grid gap-4">
          {features.map((feature, index) => {
            const Icon = feature.icon
            
            return (
              <div key={index} className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Icon size={20} className="text-blue-600" />
                </div>
                
                <div>
                  <h4 className="font-semibold mb-1">{feature.title}</h4>
                  <p className="text-sm text-gray-600">{feature.description}</p>
                </div>
              </div>
            )
          })}
        </div>
        
        <div className="mt-6 p-4 bg-blue-50 rounded-lg">
          <h4 className="font-semibold text-blue-800 mb-2">Available Games</h4>
          <div className="grid grid-2 gap-2 text-sm">
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 bg-blue-500 rounded-full"></span>
              Rock Paper Scissors
            </div>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 bg-purple-500 rounded-full"></span>
              Coin Flip
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Login 