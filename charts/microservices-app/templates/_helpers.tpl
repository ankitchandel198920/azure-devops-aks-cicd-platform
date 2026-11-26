{{- define "microservices-app.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: enterprise-microservices
app.kubernetes.io/environment: {{ .Values.global.environment }}
{{- end -}}
