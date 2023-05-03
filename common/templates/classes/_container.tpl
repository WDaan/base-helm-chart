{{- define "common.classes.container" -}}
- name: {{ (default (include "common.helpers.names.fullname" .) .Values.name) }}
  image: {{ printf "%s:%s" .Values.image.repository (default .Chart.Version .Values.image.tag) | quote }}
  imagePullPolicy: {{ (default "IfNotPresent" .Values.image.pullPolicy) }}
  {{- with .Values.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if .Values.securityContext }}
  securityContext:
    {{- toYaml .Values.securityContext | nindent 4 }}
  {{- else }}
  securityContext:
    allowPrivilegeEscalation: false
    capabilities:
      drop:
      - ALL
    privileged: false
    readOnlyRootFilesystem: false
    runAsUser: 1000
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}

  {{- with .Values.env }}
  env:
    {{- get (fromYaml (include "common.classes.env_vars" $)) "env" | toYaml | nindent 4 -}}
  {{- end }}
  {{- if or .Values.envFrom .Values.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "common.helpers.names.fullname" . }}
    {{- end }}
  {{- end }}
  ports:
  {{- include "common.classes.ports" . | trim | nindent 4 }}
  {{- with (include "common.classes.volumemounts" . | trim) }}
  volumeMounts:
    {{- nindent 4 . }}
  {{- end }}
  {{- include "common.classes.probes" . | trim | nindent 2 }}
  {{- with .Values.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
