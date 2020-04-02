kind: Service
apiVersion: v1
metadata:
  name: fredboat-postgres-service
spec:
  selector:
    app: fredboat-postgres
  ports:
    - protocol: TCP
      port: {{ POSTGRES_PORT }}
      targetPort: {{ POSTGRES_PORT }}
