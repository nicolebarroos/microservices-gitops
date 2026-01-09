{{- define "platform-lib.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "platform-lib.fullname" . }}
  labels:
    {{- include "platform-lib.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicas }}
  strategy:
    type: {{ .Values.deployment.strategy.type }}
    {{- if eq .Values.deployment.strategy.type "RollingUpdate" }}
    rollingUpdate:
      maxSurge: {{ .Values.deployment.strategy.rollingUpdate.maxSurge }}
      maxUnavailable: {{ .Values.deployment.strategy.rollingUpdate.maxUnavailable }}
    {{- end }}
  selector:
    matchLabels:
      {{- include "platform-lib.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "platform-lib.selectorLabels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    spec:
      {{- if .Values.serviceAccount.create }}
      serviceAccountName: {{ default (include "platform-lib.fullname" .) .Values.serviceAccount.name }}
      {{- else if .Values.serviceAccount.name }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      containers:
        - name: {{ include "platform-lib.name" . }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort }}
          {{- if .Values.probes.enabled }}
          livenessProbe:
            httpGet:
              path: {{ .Values.probes.liveness.path }}
              port: {{ .Values.probes.liveness.port }}
            initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
            periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
            timeoutSeconds: {{ .Values.probes.liveness.timeoutSeconds }}
            failureThreshold: {{ .Values.probes.liveness.failureThreshold }}
          readinessProbe:
            httpGet:
              path: {{ .Values.probes.readiness.path }}
              port: {{ .Values.probes.readiness.port }}
            initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
            periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
            timeoutSeconds: {{ .Values.probes.readiness.timeoutSeconds }}
            failureThreshold: {{ .Values.probes.readiness.failureThreshold }}
          {{- end }}
          env:
            {{- range $k, $v := .Values.env }}
            - name: {{ $k }}
              value: {{ $v | quote }}
            {{- end }}
          {{- if and .Values.envFromConfigMap .Values.configMap.enabled }}
          envFrom:
            - configMapRef:
                name: {{ include "platform-lib.fullname" . }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
{{- end -}}
