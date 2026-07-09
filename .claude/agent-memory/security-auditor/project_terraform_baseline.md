---
name: project-terraform-baseline
description: Baseline security posture of terraform/ (S3+CloudFront static site) as of last audit, and recurring gaps to re-check on future audits
metadata:
  type: project
---

Repo `terraform/` (files: providers.tf, variables.tf, main.tf, outputs.tf, backend.tf) provisions a
static portfolio site: private S3 bucket + CloudFront with OAC. As of the 2026-07-09 audit:

**Already correctly implemented (do not re-flag unless changed):**
- S3 `aws_s3_bucket_public_access_block` with all 4 flags true, plus `BucketOwnerEnforced` ownership controls.
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI.
- S3 bucket policy scoped via `AWS:SourceArn` condition to the specific CloudFront distribution ARN (no wildcards), `depends_on` public_access_block.
- `viewer_protocol_policy = "redirect-to-https"` on default_cache_behavior — HTTP to HTTPS redirect satisfied.
- No hardcoded account IDs/ARNs/secrets anywhere in these files.
- No IAM resources or OIDC trust policies exist in this file set (any GitHub Actions OIDC role definitions live elsewhere, not yet audited — check `.github/workflows/` and any separate IAM tf if asked to audit CI/CD deploy role).

**Recurring gaps found (re-verify each audit until fixed):**
- No `aws_s3_bucket_server_side_encryption_configuration` resource (relies on AWS default SSE-S3, not explicit).
- No `aws_s3_bucket_versioning` on the site bucket.
- No S3 access logging and no CloudFront `logging_config` block.
- No `aws_cloudfront_response_headers_policy` attached to default_cache_behavior — missing CSP, X-Frame-Options, HSTS, etc. This is a checklist requirement, keep flagging until added.
- `viewer_certificate` hardcodes `cloudfront_default_certificate = true` while `aliases` is conditionally populated from `var.domain_name`. If a custom domain is ever set, this is invalid (CloudFront requires an ACM cert + `minimum_protocol_version` for custom domain aliases) — flag as HIGH whenever `var.domain_name` default/usage changes.
- No AWS WAFv2 web ACL associated with the CloudFront distribution (optional/LOW, but worth noting each time).
- `backend.tf` remote state (S3) is intentionally commented out for bootstrap; when uncommented, verify the state bucket itself has versioning, encryption, and public access block — this repo's own IaC does not manage its own state bucket.

**How to apply:** When re-auditing this repo, diff against this list — only report NEW issues in detail, and for the recurring gaps above just confirm still-present/resolved rather than re-deriving from scratch.
