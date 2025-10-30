# 🥊 Fitness & Combat Sports Platform

<div align="center">

[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React Native](https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://reactnative.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)

**All-in-one platform for gyms, martial arts academies, and fitness professionals**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Development](#-development) • [Contributing](#-contributing)

</div>

## 🚀 Overview

Fitness & Combat Sports Platform is a comprehensive white-label solution that combines workout tracking, nutrition management, community features, and business tools specifically designed for martial arts academies, gyms, and fitness professionals.

### 🎯 Key Features

- **🏋️ Exercise Database** - 1000+ exercises with video demonstrations
- **📊 Workout Planning** - Create, share, and track workout plans
- **🍎 Nutrition Tracking** - Barcode scanner & food database
- **👥 Community** - Groups, chat, and social features
- **📅 Scheduling** - Class booking and management
- **🎨 White-label** - Fully customizable for each academy
- **📱 Mobile First** - React Native app for iOS & Android

## 🏗️ Architecture

```ascii
┌─────────────────┐ ┌──────────────────┐ ┌─────────────────┐
│ Mobile App │────│ API Gateway │────│ Microservices │
│ (React Native) │ │ (Node.js) │ │ Architecture │
└─────────────────┘ └──────────────────┘ └─────────────────┘
┌─────────────────┐ │ ┌─────────────────┐
│ Web Admin │─────────────┘ │ Databases │
│ (Next.js) │ │ (PostgreSQL + │
└─────────────────┘ │ MongoDB) │
                    └─────────────────┘
```


## 🛠️ Tech Stack


### Frontend

- **Mobile:** React Native with TypeScript
- **Web Admin:** Next.js 14 with App Router
- **UI Libraries:** NativeBase, Shadcn/ui
- **State Management:** Redux Toolkit, React Query


### Backend

- **Runtime:** Node.js with TypeScript
- **Framework:** FastAPI (Python) for microservices
- **API:** GraphQL with REST fallback
- **Authentication:** JWT with refresh tokens


### Database

- **Primary:** PostgreSQL for relational data
- **Nutrition:** MongoDB for flexible food schema
- **Cache:** Redis for performance
- **Search:** Elasticsearch for advanced queries


### Infrastructure

- **Containerization:** Docker & Docker Compose
- **CI/CD:** GitHub Actions
- **Monitoring:** Prometheus & Grafana
- **Cloud:** AWS/Azure/Google Cloud

## 🚦 Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- MongoDB 6+
- Docker (optional)


### Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/your-username/fitness-combat-platform.git
    cd fitness-combat-platform
    ```

1. **Install dependencies**

    ```bash
    npm install
    ```

1. **Setup environment variables**

    ```bash
    cp .env.example .env
    # Edit .env with your database credentials
    ```

1. **Start development environment**

    ```bash
    # Start all services
    npm run dev

    # Or start individually
    npm run dev:mobile
    npm run dev:web
    npm run dev:api
    ```


## Development Scripts

```bash
npm run dev          # Start all services
npm run build        # Build all packages
npm run test         # Run all tests
npm run test:watch   # Run tests in watch mode
npm run lint         # Run linter
npm run type-check   # Run TypeScript compiler
```

## 📁 Project Structure

```tree
fitness-combat-platform/
├── 📱 apps/
│   ├── mobile/                 # React Native App
│   ├── web-admin/             # Next.js Admin Portal
│   └── web-public/            # Marketing Site
├── 🗄️ packages/
│   ├── api-gateway/           # API Gateway
│   ├── auth-service/          # Authentication
│   ├── exercise-service/      # Exercises & Workouts
│   ├── nutrition-service/     # Nutrition & Food DB
│   ├── community-service/     # Groups & Chat
│   └── shared/               # Shared Utilities
├── 📚 docs/                  # Documentation
├── 🛠️ scripts/              # Development Scripts
└── 🔧 infrastructure/        # DevOps Configs
```


## 🤝 Contributing

We love contributions! Please see our Contributing Guide for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


### Code Standards

- Use TypeScript for all new code
- Follow the existing code style
- Write tests for new features
- Update documentation as needed


## 📊 Project Status

- **Current Phase:** MVP Development
- **Next Milestone:** Authentication & Exercise Database
- **Target Release:** Q2 2024


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 🙏 Acknowledgments

- Exercise data from various open sources
- Nutrition database integration with Open Food Facts
- Icons from Heroicons and Lucide React

---

Built with ❤️ for the fitness and martial arts community

[Report Bug](../../issues) · [Request Feature](../../issues)
