{{- define "platform-lib.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-lib.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "platform-lib.name" . -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "platform-lib.labels" -}}
app.kubernetes.io/name: {{ include "platform-lib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/part-of: microservices-platform
{{- end -}}

{{- define "platform-lib.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-lib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
