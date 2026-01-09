{{- define "platform-lib.configmap" -}}
{{- if .Values.configMap.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "platform-lib.fullname" . }}
  labels:
    {{- include "platform-lib.labels" . | nindent 4 }}
data:
  {{- toYaml .Values.configMap.data | nindent 2 }}
{{- end }}
{{- end -}}
