{{- define "traefik.service-metadata" }}
  labels:
  {{- include "traefik.labels" . | nindent 4 -}}
  {{- with .Values.service.labels }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}

{{- define "traefik.service-spec" -}}
  {{- $type := .Values.hub.enabled | ternary "ClusterIP" (default "LoadBalancer" .Values.service.type) }}
  type: {{ $type }}
  {{- with .Values.service.spec }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
  selector:
    app.kubernetes.io/name: {{ template "traefik.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
  {{- if eq $type "LoadBalancer" }}
  {{- with .Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
  {{- toYaml . | nindent 2 }}
  {{- end -}}
  {{- end -}}
  {{- with .Values.service.externalIPs }}
  externalIPs:
  {{- toYaml . | nindent 2 }}
  {{- end -}}
  {{- if .Values.service.ipFamilyPolicy }}
  ipFamilyPolicy: {{ .Values.service.ipFamilyPolicy }}
  {{- end }}
  {{- with .Values.service.ipFamilies }}
  ipFamilies:
  {{- toYaml . | nindent 2 }}
  {{- end -}}
{{- end }}
