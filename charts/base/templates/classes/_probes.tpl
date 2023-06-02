{{- define "base.classes.probes" -}}
{{ $primaryPort := include "base.helpers.primary_port" . }}
{{- range $probeName, $probe := .Values.probes }}
  {{- if $probe.enabled -}}
    {{- "" | nindent 0 }}
    {{- $probeName }}Probe:
    {{- if $probe.custom -}}
      {{- $probe.spec | toYaml | nindent 2 }}
    {{- else }}
        {{- "httpGet:" | nindent 2 }}
          {{- printf "path: %v" (default "/" $probe.path) | nindent 4 }}
            {{- printf "port: %v" $primaryPort | nindent 4 }}
        {{- $spec := merge $probe ($probe.spec | default dict) }}
        {{- (printf "initialDelaySeconds: %v" (default 5 $spec.initialDelaySeconds)) | nindent 2 }}
        {{- (printf "failureThreshold: %v" (default 5 $spec.failureThreshold)) | nindent 2 }}
        {{- (printf "timeoutSeconds: %v" (default 1 $spec.timeoutSeconds))  | nindent 2 }}
        {{- (printf "periodSeconds: %v" (default 5 $spec.periodSeconds)) | nindent 2 }}
        {{- (printf "successThreshold: %v" (default 1 $spec.successThreshold)) | nindent 2 }}
      {{- end }}
  {{- end }}
{{- end }}
{{- end }}
