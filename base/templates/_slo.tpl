{{/* Renders the frontendConfig objects required by the chart */}}
{{- define "base.slo" -}}
{{- if ((.Values.metrics).slo).enabled }}
---
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: {{ include "base.helpers.names.fullname" . }}
  labels: {{- include "base.helpers.labels" $ | nindent 4 }}
  annotations: {{- include "base.helpers.annotations" $ | nindent 4 }}
spec:
  groups:
  {{- range $key, $slo := .Values.metrics.slo.slos }}
  - name: sloth-slo-sli-recordings-{{ $.Chart.Name }}-{{ $slo.name }}
    rules:
    - record: slo:sli_error:ratio_rate5m
      expr: |
        ({{ $slo.query | replace ".window" "5m" | indent 8  }})
        /
        ({{ $slo.totalQuery | replace ".window" "5m" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 5m
    - record: slo:sli_error:ratio_rate30m
      expr: |
        ({{ $slo.query | replace ".window" "30m" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "30m" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 30m
    - record: slo:sli_error:ratio_rate1h
      expr: |
        ({{ $slo.query | replace ".window" "1h" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "1h" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 1h
    - record: slo:sli_error:ratio_rate2h
      expr: |
        ({{ $slo.query | replace ".window" "2h" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "2h" | indent 8 }})
      labels:
        
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 2h
    - record: slo:sli_error:ratio_rate6h
      expr: |
        ({{ $slo.query | replace ".window" "6h" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "6h" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 6h
    - record: slo:sli_error:ratio_rate1d
      expr: |
        ({{ $slo.query | replace ".window" "1d" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "1d" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 1d
    - record: slo:sli_error:ratio_rate3d
      expr: |
        ({{ $slo.query | replace ".window" "3d" | indent 8 }})
        /
        ({{ $slo.totalQuery | replace ".window" "3d" | indent 8 }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 3d
    - record: slo:sli_error:ratio_rate30d
      expr: |
        sum_over_time(slo:sli_error:ratio_rate5m{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}[30d])
        / ignoring (sloth_window)
        count_over_time(slo:sli_error:ratio_rate5m{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}[30d])
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_window: 30d
  - name: sloth-slo-meta-recordings-{{ $.Chart.Name }}-{{ $slo.name }}
    rules:
    - record: slo:objective:ratio
      expr: vector({{ $slo.objective }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: slo:error_budget:ratio
      expr: vector(1-{{ $slo.objective }})
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: slo:time_period:days
      expr: vector(30)
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: slo:current_burn_rate:ratio
      expr: |
        slo:sli_error:ratio_rate5m{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}
        / on(sloth_id, sloth_slo, sloth_service) group_left
        slo:error_budget:ratio{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: slo:period_burn_rate:ratio
      expr: |
        slo:sli_error:ratio_rate30d{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}
        / on(sloth_id, sloth_slo, sloth_service) group_left
        slo:error_budget:ratio{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: slo:period_error_budget_remaining:ratio
      expr: 1 - slo:period_burn_rate:ratio{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}",
        sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"}
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
    - record: sloth_slo_info
      expr: vector(1)
      labels:
        sloth_id: {{ $.Chart.Name }}-{{ $slo.name }}
        sloth_mode: cli-gen-prom
        sloth_objective: "{{ mulf $slo.objective 100 }}"
        sloth_service: {{ $.Chart.Name }}
        sloth_slo: {{ $slo.name }}
        sloth_spec: prometheus/v1
        sloth_version: v0.11.0
{{- if ($slo.alerting).enabled }}
  - name: sloth-slo-alerts-{{ $.Chart.Name }}-{{ $slo.name }}
    rules:
    - alert: {{ $slo.alerting.name }} 
      expr: |
        (
            max(slo:sli_error:ratio_rate5m{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (14.4 * {{ subf 1 $slo.objective }})) without (sloth_window)
            and
            max(slo:sli_error:ratio_rate1h{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (14.4 * {{ subf 1 $slo.objective }})) without (sloth_window)
        )
        or
        (
            max(slo:sli_error:ratio_rate30m{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (6 * {{ subf 1 $slo.objective }})) without (sloth_window)
            and
            max(slo:sli_error:ratio_rate6h{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (6 * {{ subf 1 $slo.objective }})) without (sloth_window)
        )
      labels:
{{- toYaml $slo.alerting.labels | nindent 8 }}
        env: {{ default "unknown" ($.Values.env).ENVIRONMENT }}
        severity: warning
      annotations:
        summary: {{ $slo.alerting.title }}
        title: {{ $slo.alerting.title }}
{{- if and ($slo.alerting).enabled (not ($slo.alerting).disableCritical) }}
    - alert: {{ $slo.alerting.name }} (Critical)
      expr: |
        (
            max(slo:sli_error:ratio_rate2h{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (3 * {{ subf 1 $slo.objective }})) without (sloth_window)
            and
            max(slo:sli_error:ratio_rate1d{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (3 * {{ subf 1 $slo.objective }})) without (sloth_window)
        )
        or
        (
            max(slo:sli_error:ratio_rate6h{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (1 * {{ subf 1 $slo.objective }})) without (sloth_window)
            and
            max(slo:sli_error:ratio_rate3d{sloth_id="{{ $.Chart.Name }}-{{ $slo.name }}", sloth_service="{{ $.Chart.Name }}", sloth_slo="{{ $slo.name }}"} > (1 * {{ subf 1 $slo.objective }})) without (sloth_window)
        )
      labels:
{{- toYaml $slo.alerting.labels | nindent 8 }}
        env: {{ default "unknown" ($.Values.env).ENVIRONMENT }}
        severity: critical
      annotations:
        summary: {{ $slo.alerting.title }}
        title: {{ $slo.alerting.title }} (Critical)
{{- end }}
{{- end }}
  {{- end }}
{{- end }}
{{- end }}
