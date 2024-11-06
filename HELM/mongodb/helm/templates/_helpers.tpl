{{/* Define a full name function that combines release and chart name, truncated to 63 characters */}}
{{- define "mychart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define a simple name function for the application */}}
{{- define "mychart.name" -}}
myapp
{{- end -}}

{{/* Define a function for generating standard labels */}}
{{- define "mychart.labels" -}}
app: {{ template "mychart.name" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/* Define a function for Deployment-specific labels, if needed */}}
{{- define "mychart.deploymentLabels" -}}
{{ include "mychart.labels" . }}
tier: backend
{{- end -}}

{{/* Define a function for Service-specific labels, if needed */}}
{{- define "mychart.serviceLabels" -}}
{{ include "mychart.labels" . }}
service-type: main
{{- end -}}
