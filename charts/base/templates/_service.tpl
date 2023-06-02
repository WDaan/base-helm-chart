{{- define "base.service" }}
{{ $svcType := .Values.service.type }}
{{ $port := include "base.helpers.primary_port" . }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "base.helpers.names.fullname" $ }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations:
  {{- if (.Values.metrics).useAnnotations }}
    prometheus.io/scrape: "true"
    prometheus.io/path: {{ (default "/metrics" .Values.metrics.path) }}
    prometheus.io/port: {{ (default $port .Values.metrics.port) | quote }}
  {{- end -}}
  {{- with include "base.helpers.annotations" $ | fromYaml -}}
    {{ toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if (or (eq $svcType "ClusterIP") (empty $svcType)) }}
  type: ClusterIP
  {{- if .Values.service.clusterIP }}
  clusterIP: {{ .Values.service.clusterIP }}
  {{end}}
  {{- else if eq $svcType "LoadBalancer" }}
  type: {{ $svcType }}
  {{- if .Values.service.loadBalancerIP }}
  loadBalancerIP: {{ .Values.service.loadBalancerIP }}
  {{- end }}
  {{- if .Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
    {{ toYaml .Values.service.loadBalancerSourceRanges | nindent 4 }}
  {{- end -}}
  {{- else }}
  type: {{ $svcType }}
  {{- end }}
  {{- if .Values.service.externalTrafficPolicy }}
  externalTrafficPolicy: {{ .Values.service.externalTrafficPolicy }}
  {{- end }}
  {{- if .Values.service.sessionAffinity }}
  sessionAffinity: {{ .Values.service.sessionAffinity }}
  {{- if .Values.service.sessionAffinityConfig }}
  sessionAffinityConfig:
    {{ toYaml .Values.service.sessionAffinityConfig | nindent 4 }}
  {{- end -}}
  {{- end }}
  {{- with .Values.service.externalIPs }}
  externalIPs:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.service.publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ .Values.service.publishNotReadyAddresses }}
  {{- end }}
  {{- if .Values.service.ipFamilyPolicy }}
  ipFamilyPolicy: {{ .Values.service.ipFamilyPolicy }}
  {{- end }}
  {{- with .Values.service.ipFamilies }}
  ipFamilies:
    {{ toYaml . | nindent 4 }}
  {{- end }}
  ports:
  {{- range .Values.service.ports }}
  - port: {{ .port }}
    targetPort: {{ .targetPort | default .port }}
    {{- if .protocol }}
    {{- if or ( eq .protocol "HTTP" ) ( eq .protocol "HTTPS" ) ( eq .protocol "TCP" ) }}
    protocol: TCP
    {{- else }}
    protocol: {{ .protocol }}
    {{- end }}
    {{- else }}
    protocol: TCP
    {{- end }}
    name: {{ .name }}
    {{- if (and (eq $svcType "NodePort") (not (empty .nodePort))) }}
    nodePort: {{ .nodePort }}
    {{ end }}
  {{- end }}
  selector:
    {{- include "base.helpers.labels.selectorLabels" . | nindent 4 }}
{{- end }}
