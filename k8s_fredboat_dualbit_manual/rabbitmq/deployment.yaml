apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-rabbitmq
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-rabbitmq
  template:
    metadata:
      labels:
        app: fredboat-rabbitmq
    spec:
      containers:
        - name: fredboat-rabbitmq
          image: rabbitmq:3-management
          imagePullPolicy: Always
          ports:
            - containerPort: 5672
            - containerPort: 15672
