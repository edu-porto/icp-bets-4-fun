import React from 'react'
import { User, LogOut, Home, Gamepad2, PiggyBank, TestTube } from 'lucide-react'

interface UserProfile {
  id: any;
  username?: string;
  balance: number;
  createdAt: number;
  lastActive: number;
}

interface HeaderProps {
  userProfile?: UserProfile | null;
  onLogout?: () => void;
  currentView: 'dashboard' | 'games' | 'treasury';
  onViewChange: (view: 'dashboard' | 'games' | 'treasury') => void;
  isTestMode?: boolean;
}

const Header: React.FC<HeaderProps> = ({ 
  userProfile, 
  onLogout, 
  currentView, 
  onViewChange,
  isTestMode = false
}) => {
  const navigationItems = [
    { id: 'dashboard', label: 'Dashboard', icon: Home },
    { id: 'games', label: 'Games', icon: Gamepad2 },
    { id: 'treasury', label: 'Treasury', icon: PiggyBank },
  ]

  return (
    <header className="card mb-6">
      <div className="flex justify-between items-center">
        <div className="flex items-center gap-4">
          <h1 className="text-2xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
            ICP Bets
          </h1>
          
          {isTestMode && (
            <div className="flex items-center gap-2 px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm font-medium">
              <TestTube size={16} />
              Test Mode
            </div>
          )}
          
          {userProfile && (
            <nav className="flex gap-2">
              {navigationItems.map((item) => {
                const Icon = item.icon
                const isActive = currentView === item.id
                
                return (
                  <button
                    key={item.id}
                    onClick={() => onViewChange(item.id as any)}
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                      isActive 
                        ? 'bg-blue-100 text-blue-700 border border-blue-200' 
                        : 'text-gray-600 hover:bg-gray-100'
                    }`}
                  >
                    <Icon size={18} />
                    {item.label}
                  </button>
                )
              })}
            </nav>
          )}
        </div>

        {userProfile && (
          <div className="flex items-center gap-4">
            <div className="text-right">
              <div className="text-sm text-gray-600">
                {userProfile.username || 'Player'}
              </div>
              <div className="text-lg font-semibold text-green-600">
                {userProfile.balance.toLocaleString()} Credits
              </div>
            </div>
            
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
                <User size={20} className="text-white" />
              </div>
              
              {onLogout && (
                <button
                  onClick={onLogout}
                  className="flex items-center gap-2 px-3 py-2 text-gray-600 hover:text-red-600 transition-colors"
                  title="Logout"
                >
                  <LogOut size={18} />
                </button>
              )}
            </div>
          </div>
        )}
      </div>
    </header>
  )
}

export default Header 