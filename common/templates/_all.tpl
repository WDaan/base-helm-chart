{{- define "common.all" -}}
  {{ include "common.deployment" . }}
  {{ include "common.configmap" . }}
  {{ include "common.serviceAccount" . }}
  {{ include "common.rbac" . }}
  {{ include "common.hpa" . }}
  {{ include "common.service" . }}
  {{ include "common.ingress" . }}
  {{ include "common.slo" . }}
  {{ include "common.secret" . }}
  {{ include "common.serviceMonitor" . }}
  {{ include "common.pdb" . }}
{{- end -}}
