kind: Service
apiVersion: v1
metadata:
  name: fredboat-rabbitmq-service
spec:
  selector:
    app: fredboat-rabbitmq
  ports:
    - protocol: TCP
      name: broker
      port: 5672
      targetPort: 5672
    - protocol: TCP
      name: webui
      port: 15672
      targetPort: 15672
