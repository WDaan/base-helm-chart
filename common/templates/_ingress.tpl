{{- define "common.ingress" }}
{{- if (.Values.ingress).enabled }}
  {{- $values := .Values.ingress -}}
  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.ingress -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

{{ $defaultService := (index .Values.service.ports 0) }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.helpers.names.fullname" . }}
  {{- with (merge ($values.labels | default dict) (include "common.helpers.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.helpers.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if $values.ingressClassName }}
  ingressClassName: {{ $values.ingressClassName }}
  {{- end }}
  {{- if $values.tls }}
  tls:
    {{- range $values.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ tpl . $ | quote }}
        {{- end }}
      {{- if .secretName }}
      secretName: {{ tpl .secretName $ | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $values.hosts }}
    - host: {{ tpl .host $ | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ tpl .path $ | quote }}
            pathType: {{ default "Prefix" .pathType }}
            backend:
              service:
                name: {{ include "common.helpers.names.fullname" $ }}
                port:
                  number: {{ $defaultService.port }}
          {{- end }}
  {{- end }}
{{- end }}
{{- end }}
