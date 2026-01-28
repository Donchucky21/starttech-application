
---

## CI/CD Pipelines

### 1) Frontend Pipeline (React → S3 + CloudFront)
Workflow: `.github/workflows/frontend-ci-cd.yml`

**Stages**
- Install dependencies
- Run tests (if configured)
- Build production bundle
- Security scan (npm audit)
- Deploy: sync build artifacts to S3
- Invalidate CloudFront cache

**Deploy target**
- S3 static hosting bucket created by Terraform
- CloudFront distribution created by Terraform

---

### 2) Backend Pipeline (Golang → ECR → EC2 ASG behind ALB)
Workflow: `.github/workflows/backend-ci-cd.yml`

**Stages**
- Unit tests + linting / code quality checks
- Security scanning (gosec) + container scan (Trivy)
- Build Docker image
- Push image to ECR
- Trigger rolling deployment (ASG instance refresh)
- Smoke test against ALB `/health`

**Deploy target**
- EC2 Auto Scaling Group behind ALB created by Terraform
- CloudWatch logs enabled via instance role / log group

---

## Local Development (Optional)

### Backend
From the backend folder:
- Copy `.env.example` to `.env` and set required values
- Run with Docker Compose if provided, or run the Go binary locally

### Frontend
From the frontend folder:
- Copy `.env.example` to `.env`
- Ensure `VITE_API_BASE_URL` points to the backend URL
- Install and run:
  - `npm install`
  - `npm run dev`

---

## Required GitHub Secrets
These must be configured in the GitHub repository settings to allow deployments:

### AWS / Deployment
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### Frontend Deployment
- `S3_BUCKET_NAME` (frontend bucket)
- `CLOUDFRONT_DISTRIBUTION_ID`

### Backend Deployment
- `ECR_REPOSITORY` (or ECR repo URI)
- `ASG_NAME` (Auto Scaling Group name)
- (Optional) `ALB_HEALTHCHECK_URL` (e.g. https://api.starttechapp.uk/health)

> If your workflow uses different secret names, list them here to match your pipeline config.

---

## Scripts Usage
Scripts are provided in `scripts/` and can be used locally or by CI jobs.

### Deploy frontend
```bash
./scripts/deploy-frontend.sh
