kind: Service
apiVersion: v1
metadata:
  name: fredboat-fredboat-service
spec:
  selector:
    app: fredboat-fredboat
  ports:
    - protocol: TCP
      port: {{ FREDBOAT_PORT }}
      targetPort: {{ FREDBOAT_PORT }}
