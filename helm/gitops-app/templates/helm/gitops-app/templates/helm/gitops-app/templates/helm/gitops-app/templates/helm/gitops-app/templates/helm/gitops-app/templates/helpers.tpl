{{/*
Chart name
*/}}

{{- define "gitops-app.name" -}}

{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}

{{- end }}



{{/*
Full resource name
*/}}

{{- define "gitops-app.fullname" -}}

{{- printf "%s-%s" .Release.Name (include "gitops-app.name" .) | trunc 63 | trimSuffix "-" }}

{{- end }}



{{/*
Common labels
*/}}

{{- define "gitops-app.labels" -}}

app.kubernetes.io/name: {{ include "gitops-app.name" . }}

helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}

app.kubernetes.io/instance: {{ .Release.Name }}

app.kubernetes.io/managed-by: {{ .Release.Service }}

{{- end }}



{{/*
Selector labels
*/}}

{{- define "gitops-app.selectorLabels" -}}

app.kubernetes.io/name: {{ include "gitops-app.name" . }}

app.kubernetes.io/instance: {{ .Release.Name }}

{{- end }}
