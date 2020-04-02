kind: Service
apiVersion: v1
metadata:
  name: fredboat-quarterdeck-service
spec:
  selector:
    app: fredboat-quarterdeck
  ports:
    - protocol: TCP
      port: {{ QUARTERDECK_PORT }}
      targetPort: {{ QUARTERDECK_PORT }}
