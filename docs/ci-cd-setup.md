# CI/CD Pipeline Setup Guide

This document provides comprehensive information about the CI/CD pipeline setup for the Fitness & Combat Sports Platform.

## Overview

The CI/CD pipeline is built using GitHub Actions and includes:

- **Continuous Integration (CI)**: Automated testing, building, and quality checks
- **Continuous Deployment (CD)**: Automated deployment to staging and production environments
- **Monitoring & Alerting**: Prometheus-based monitoring with comprehensive alerting rules
- **Security Scanning**: CodeQL analysis and dependency vulnerability scanning

## Pipeline Architecture

```ascii
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Code Push     │───▶│   CI Pipeline    │───▶│   CD Pipeline   │
│   (GitHub)      │    │   (GitHub Actions)│    │   (Kubernetes)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌──────────────────┐    ┌─────────────────┐
                       │   Quality Gates  │    │   Deployments   │
                       │   • Linting      │    │   • Staging     │
                       │   • Testing      │    │   • Production  │
                       │   • Security     │    │   • Rollback    │
                       └──────────────────┘    └─────────────────┘
```

## CI Pipeline Features

### 1. Code Quality & Security
- **Linting**: ESLint with TypeScript support
- **Type Checking**: TypeScript compilation validation
- **Security Scanning**: npm audit and CodeQL analysis
- **Dependency Validation**: Package integrity checks

### 2. Build & Test
- **Parallel Builds**: Matrix strategy for different packages
- **Caching**: npm dependency caching for faster builds
- **Artifact Storage**: Build artifacts stored for 7 days
- **Multi-package Support**: Builds shared, API gateway, mobile, and web admin

### 3. Integration Tests
- **Database Services**: PostgreSQL and MongoDB test instances
- **Health Checks**: Service availability validation
- **Smoke Tests**: Basic functionality verification

### 4. Security & Compliance
- **License Checking**: Automated license compliance
- **High-level Security**: Strict security scanning for main branch
- **Audit Reports**: Detailed security audit logs

## CD Pipeline Features

### 1. Environment Management
- **Staging Environment**: Automated deployment for testing
- **Production Environment**: Blue-Green deployment strategy
- **Manual Triggers**: Support for manual deployments via workflow dispatch

### 2. Deployment Strategy
- **Blue-Green Deployment**: Zero-downtime production deployments
- **Health Checks**: Comprehensive service health validation
- **Rollback Mechanism**: Automated rollback on deployment failure
- **Database Migrations**: Automated database schema updates

### 3. Monitoring & Validation
- **Pre-deployment Checks**: Validation before deployment
- **Post-deployment Monitoring**: 5-minute monitoring period
- **Health Endpoints**: Dedicated health check endpoints
- **Service Discovery**: Kubernetes service management

## Configuration Files

### GitHub Actions Workflows
- `.github/workflows/ci.yml` - Continuous Integration pipeline
- `.github/workflows/cd.yml` - Continuous Deployment pipeline

### Docker Configuration
- `infrastructure/docker/Dockerfile.api-gateway` - API Gateway container
- `infrastructure/docker/Dockerfile.web-admin` - Web Admin container
- `infrastructure/docker/nginx.conf` - Nginx configuration for web admin

### Kubernetes Configuration
- `infrastructure/k8s/staging/configmap.yaml` - Staging environment configuration
- `infrastructure/k8s/staging/secrets.yaml` - Staging environment secrets

### Deployment Scripts
- `scripts/deploy-staging.sh` - Staging deployment automation
- `scripts/deploy-production.sh` - Production deployment automation

### Monitoring Configuration
- `infrastructure/monitoring/prometheus-config.yaml` - Prometheus monitoring setup
- `infrastructure/monitoring/alert-rules.yml` - Alerting rules configuration

## Environment Variables

### Required Secrets
The following secrets must be configured in GitHub repository settings:

```bash
# Container Registry
GITHUB_TOKEN                    # GitHub Container Registry access

# Kubernetes
KUBE_CONFIG                     # Kubernetes cluster configuration

# Monitoring
SLACK_WEBHOOK_URL              # Slack notifications (optional)
EMAIL_ALERTS                   # Email alert configuration (optional)
```

### Environment Configuration
Environment-specific configuration is managed through Kubernetes ConfigMaps and Secrets:

- **Staging**: `fitness-combat-staging` namespace
- **Production**: `fitness-combat-production` namespace

## Deployment Process

### Staging Deployment
1. **Trigger**: Automatic on push to `develop` branch
2. **Process**:
   - Build and package services
   - Deploy to staging environment
   - Run health checks and smoke tests
   - Notify completion

### Production Deployment
1. **Trigger**: Automatic on push to `main` branch or manual via workflow dispatch
2. **Process**:
   - Pre-deployment validation
   - Blue-Green deployment
   - Health checks and monitoring
   - Traffic switching
   - Cleanup and rollback preparation

## Monitoring & Alerting

### Metrics Collected
- **Application Metrics**: Response times, error rates, request volumes
- **Infrastructure Metrics**: CPU, memory, disk usage
- **Kubernetes Metrics**: Pod status, deployment health, resource usage
- **Database Metrics**: Connection counts, query performance

### Alert Categories
- **Critical**: Service downtime, database failures, high error rates
- **Warning**: High resource usage, slow response times, security issues
- **Info**: Deployment status, configuration changes

### Alert Channels
- **Slack**: Real-time notifications for critical alerts
- **Email**: Detailed reports for warning and critical alerts
- **Dashboard**: Grafana dashboards for monitoring visualization

## Security Features

### Code Security
- **CodeQL Analysis**: Static code analysis for security vulnerabilities
- **Dependency Scanning**: Automated vulnerability detection in dependencies
- **License Compliance**: Automated license checking

### Deployment Security
- **Image Scanning**: Container vulnerability scanning with Trivy
- **Secrets Management**: Kubernetes secrets for sensitive configuration
- **Network Policies**: Kubernetes network policies for service isolation

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Check build logs
gh api repos/owner/repo/actions/runs/run_id

# Re-run failed jobs
gh api repos/owner/repo/actions/runs/run_id/rerun
```

#### Deployment Failures
```bash
# Check Kubernetes events
kubectl get events --namespace=fitness-combat-staging

# Check pod logs
kubectl logs pod-name --namespace=fitness-combat-staging

# Check deployment status
kubectl rollout status deployment/deployment-name --namespace=namespace
```

#### Monitoring Issues
```bash
# Check Prometheus targets
curl http://prometheus:9090/api/v1/targets

# Check AlertManager status
curl http://alertmanager:9093/api/v1/status
```

### Debug Commands

#### CI/CD Debug
```bash
# List workflow runs
gh api repos/owner/repo/actions/runs

# Get job details
gh api repos/owner/repo/actions/jobs/job_id

# Download logs
gh api repos/owner/repo/actions/runs/run_id/logs
```

#### Kubernetes Debug
```bash
# Check all resources
kubectl get all --all-namespaces

# Describe resources
kubectl describe deployment/deployment-name --namespace=namespace

# Port forward for local debugging
kubectl port-forward service/service-name 8080:80 --namespace=namespace
```

## Best Practices

### Code Quality
- Maintain high test coverage (>80%)
- Follow TypeScript strict mode
- Use ESLint for consistent code style
- Regular dependency updates

### Security
- Regular security scans
- Minimal container images
- Secret rotation
- Network segmentation

### Monitoring
- Set appropriate alert thresholds
- Regular dashboard reviews
- Performance baseline monitoring
- Capacity planning

### Deployment
- Blue-Green deployments for production
- Automated rollback procedures
- Database migration testing
- Environment parity

## Maintenance

### Regular Tasks
- **Weekly**: Review security scan results
- **Monthly**: Update dependencies and base images
- **Quarterly**: Review and update alert thresholds
- **Annually**: Review and update deployment procedures

### Performance Optimization
- Monitor build times and optimize caching
- Review resource allocation for services
- Optimize Docker image sizes
- Regular cleanup of old artifacts

## Support

For issues related to the CI/CD pipeline:

1. **Check Logs**: Review GitHub Actions logs and Kubernetes events
2. **Monitor Status**: Check monitoring dashboards for system health
3. **Documentation**: Refer to this guide for troubleshooting steps
4. **Team Support**: Contact the DevOps team for complex issues

## Contributing

To contribute to the CI/CD pipeline:

1. **Fork the Repository**: Create a fork of the main repository
2. **Create Branch**: Create a feature branch for your changes
3. **Test Changes**: Test your changes in a development environment
4. **Submit PR**: Create a pull request with detailed description
5. **Review Process**: Address review feedback and merge

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)