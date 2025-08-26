import React, { useState, useEffect } from 'react'
import { AuthClient } from '@dfinity/auth-client'
import { Identity } from '@dfinity/agent'
import { Principal } from '@dfinity/principal'
import Header from './components/Header'
import Login from './components/Login'
import Dashboard from './components/Dashboard'
import GameSelector from './components/GameSelector'
import TreasuryStats from './components/TreasuryStats'
import './App.css'

interface UserProfile {
  id: Principal;
  username?: string;
  balance: number;
  createdAt: number;
  lastActive: number;
}

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

function App() {
  const [authClient, setAuthClient] = useState<AuthClient | null>(null)
  const [identity, setIdentity] = useState<Identity | null>(null)
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null)
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const [isLoading, setIsLoading] = useState(true)
  const [treasuryStats, setTreasuryStats] = useState<TreasuryStatsData | null>(null)
  const [currentView, setCurrentView] = useState<'dashboard' | 'games' | 'treasury'>('dashboard')
  const [isTestMode, setIsTestMode] = useState(false)

  useEffect(() => {
    initializeAuth()
  }, [])

  const initializeAuth = async () => {
    try {
      const client = await AuthClient.create()
      setAuthClient(client)

      const isAuthenticated = await client.isAuthenticated()
      if (isAuthenticated) {
        const identity = client.getIdentity()
        setIdentity(identity)
        setIsAuthenticated(true)
        await loadUserProfile(identity)
      }
    } catch (error) {
      console.error('Failed to initialize auth client:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const loadUserProfile = async (userIdentity: Identity) => {
    try {
      // In a real implementation, you would call the auth canister here
      // For now, we'll create a mock profile
      const mockProfile: UserProfile = {
        id: userIdentity.getPrincipal(),
        username: 'Player',
        balance: 1000,
        createdAt: Date.now(),
        lastActive: Date.now()
      }
      setUserProfile(mockProfile)
    } catch (error) {
      console.error('Failed to load user profile:', error)
    }
  }

  const handleLogin = async () => {
    if (!authClient) return

    try {
      await authClient.login({
        identityProvider: process.env.NODE_ENV === 'development' 
          ? `http://localhost:4943/?canisterId=${process.env.INTERNET_IDENTITY_CANISTER_ID}`
          : 'https://identity.ic0.app',
        onSuccess: async () => {
          const identity = authClient.getIdentity()
          setIdentity(identity)
          setIsAuthenticated(true)
          await loadUserProfile(identity)
        }
      })
    } catch (error) {
      console.error('Login failed:', error)
    }
  }

  const handleLogout = async () => {
    if (!authClient) return

    try {
      await authClient.logout()
      setIdentity(null)
      setUserProfile(null)
      setIsAuthenticated(false)
    } catch (error) {
      console.error('Logout failed:', error)
    }
  }

  const handleTestMode = () => {
    // Create a mock profile for testing
    const mockProfile: UserProfile = {
      id: Principal.fromText('2vxsx-fae'), // Mock principal
      username: 'TestPlayer',
      balance: 1000,
      createdAt: Date.now(),
      lastActive: Date.now()
    }
    setUserProfile(mockProfile)
    setIsAuthenticated(true)
    setIsTestMode(true)
    loadTreasuryStats()
  }

  const updateUserBalance = (newBalance: number) => {
    if (userProfile) {
      setUserProfile({
        ...userProfile,
        balance: newBalance
      })
    }
  }

  const loadTreasuryStats = async () => {
    try {
      // In a real implementation, you would call the treasury canister here
      // For now, we'll use mock data
      const mockStats: TreasuryStatsData = {
        totalBalance: 50000,
        totalBets: 1250,
        totalWagered: 150000,
        totalWon: 75000,
        totalLost: 75000,
        totalHouseFees: 3000,
        totalDeposits: 100000,
        totalWithdrawals: 47000
      }
      setTreasuryStats(mockStats)
    } catch (error) {
      console.error('Failed to load treasury stats:', error)
    }
  }

  useEffect(() => {
    if (isAuthenticated) {
      loadTreasuryStats()
    }
  }, [isAuthenticated])

  if (isLoading) {
    return (
      <div className="container">
        <div className="card text-center">
          <div className="text-xl">Loading ICP Bets Platform...</div>
        </div>
      </div>
    )
  }

  if (!isAuthenticated) {
    return (
      <div className="container">
        <Header />
        <Login onLogin={handleLogin} onTestMode={handleTestMode} />
      </div>
    )
  }

  return (
    <div className="container">
      <Header 
        userProfile={userProfile}
        onLogout={handleLogout}
        currentView={currentView}
        onViewChange={setCurrentView}
        isTestMode={isTestMode}
      />
      
      {currentView === 'dashboard' && (
        <Dashboard 
          userProfile={userProfile}
          onBalanceUpdate={updateUserBalance}
        />
      )}
      
      {currentView === 'games' && (
        <GameSelector 
          userProfile={userProfile}
          onBalanceUpdate={updateUserBalance}
        />
      )}
      
      {currentView === 'treasury' && (
        <TreasuryStats 
          stats={treasuryStats}
          onRefresh={loadTreasuryStats}
        />
      )}
    </div>
  )
}

export default App 