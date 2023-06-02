{{- define "base.all" -}}
  {{ include "base.deployment" . }}
  {{ include "base.configmap" . }}
  {{ include "base.serviceAccount" . }}
  {{ include "base.rbac" . }}
  {{ include "base.hpa" . }}
  {{ include "base.service" . }}
  {{ include "base.ingress" . }}
  {{ include "base.slo" . }}
  {{ include "base.secret" . }}
  {{ include "base.serviceMonitor" . }}
  {{ include "base.pdb" . }}
{{- end -}}
