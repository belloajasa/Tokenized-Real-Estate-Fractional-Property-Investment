# Tokenized Real Estate Fractional Property Investment Platform

A comprehensive blockchain-based platform for fractional real estate investment using Clarity smart contracts on the Stacks blockchain.

## Overview

This platform enables fractional ownership of real estate properties through tokenization, allowing multiple investors to own shares of properties and receive proportional rental income. The system includes property verification, investment management, rental income distribution, maintenance coordination, and exit strategies.

## Smart Contracts

### 1. Property Verification Contract (`property-verification.clar`)
- **Purpose**: Validates and manages real estate property listings
- **Key Features**:
    - Property registration with address and valuation
    - Authorized verifier system
    - Property verification status tracking
    - Verification timestamp and verifier records

### 2. Investment Management Contract (`investment-management.clar`)
- **Purpose**: Manages fractional property investments and token distribution
- **Key Features**:
    - Investment pool creation for verified properties
    - Token-based fractional ownership
    - Minimum investment requirements
    - Investor holdings tracking

### 3. Rental Income Distribution Contract (`rental-income-distribution.clar`)
- **Purpose**: Distributes rental income to fractional property investors
- **Key Features**:
    - Rental income collection and tracking
    - Proportional distribution based on token holdings
    - Distribution history and records
    - Claimable income calculations

### 4. Property Maintenance Contract (`property-maintenance.clar`)
- **Purpose**: Coordinates property maintenance and expense tracking
- **Key Features**:
    - Maintenance request submission and approval
    - Cost estimation and actual expense tracking
    - Maintenance fund management
    - Request status monitoring

### 5. Exit Strategy Contract (`exit-strategy.clar`)
- **Purpose**: Manages investor exit strategies and token trading
- **Key Features**:
    - Sell order creation and management
    - Buy order execution
    - Partial order fills
    - Order book management

## Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│  Property Owner     │    │    Investors        │    │   Property Manager  │
└─────────┬───────────┘    └─────────┬───────────┘    └─────────┬───────────┘
│                          │                          │
▼                          ▼                          ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Smart Contract Layer                                │
├─────────────────┬─────────────────┬─────────────────┬─────────────────────┤
│ Property        │ Investment      │ Rental Income   │ Maintenance &       │
│ Verification    │ Management      │ Distribution    │ Exit Strategy       │
└─────────────────┴─────────────────┴─────────────────┴─────────────────────┘
\`\`\`

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository
2. Install dependencies for testing:
   \`\`\`bash
   npm install vitest
   \`\`\`

3. Deploy contracts to Stacks blockchain:
   \`\`\`bash
   clarinet deploy
   \`\`\`

### Testing

Run the test suite:
\`\`\`bash
npm test
\`\`\`

The tests cover:
- Property verification workflows
- Investment management processes
- Rental income distribution calculations
- Maintenance request handling
- Exit strategy order management

## Usage Workflow

### 1. Property Onboarding
1. Property owner registers property with address and valuation
2. Authorized verifier validates the property
3. Property becomes eligible for investment

### 2. Investment Process
1. Investment pool is created for verified property
2. Investors purchase fractional tokens
3. Token holdings represent ownership percentage

### 3. Rental Income Distribution
1. Property manager adds rental income to the system
2. Income is distributed proportionally to token holders
3. Investors can claim their share of rental income

### 4. Maintenance Management
1. Maintenance requests are submitted with cost estimates
2. Requests are approved and executed
3. Actual costs are tracked and deducted from maintenance funds

### 5. Exit Strategy
1. Investors can create sell orders for their tokens
2. Other investors can purchase tokens through buy orders
3. Orders can be partially filled or cancelled

## Key Features

- **Fractional Ownership**: Enables small investors to participate in real estate
- **Transparent Operations**: All transactions recorded on blockchain
- **Automated Distribution**: Smart contract handles rental income distribution
- **Maintenance Tracking**: Comprehensive maintenance request and expense system
- **Liquidity Options**: Secondary market for token trading
- **Verification System**: Ensures property authenticity before investment

## Security Considerations

- Contract owner permissions for critical functions
- Input validation and error handling
- Prevention of self-trading in exit strategies
- Sufficient balance checks for all transactions
- Authorized verifier system for property validation

## Future Enhancements

- Integration with real estate APIs for property data
- Automated rental income collection
- Mobile application for investors
- Integration with traditional banking systems
- Advanced analytics and reporting features
- Multi-property portfolio management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

