{{- define "defaultLabels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}

{{- define "serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ .Release.Name }}-{{ .Chart.Name }}-sa
{{- else -}}
{{ .Values.serviceAccount.name | quote }}
{{- end -}}
{{- end -}}