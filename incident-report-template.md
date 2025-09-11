# Incident Simulation Report Template

**Incident ID:** INC-YYYYMMDD-001
**Date:** YYYY-MM-DD
**Affected System(s):** linux_client (10.0.0.11)
**Summary:**
- Brief description of the incident

**Timeline:**
- T+0: Detection by Nagios / alert triggered
- T+1: Triage and assign
- T+15: Remediation steps started
- T+30: Certificate renewed and deployed via Ansible

**Root Cause:**
- e.g. Certificate expiration not renewed in time

**Mitigation & Recovery Steps:**
- Steps taken to restore service

**Lessons Learned & Action Items:**
- Add certificate auto-renewal playbook to cron / pipeline
