kind: Service
apiVersion: v1
metadata:
  name: fredboat-lavalink-service
spec:
  selector:
    app: fredboat-lavalink
  ports:
    - protocol: TCP
      port: {{ LAVALINK_PORT }}
      targetPort: {{ LAVALINK_PORT }}
