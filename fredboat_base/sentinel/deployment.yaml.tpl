apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-sentinel
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-sentinel
  template:
    metadata:
      labels:
        app: fredboat-sentinel
    spec:
      initContainers:
        - name: init-wait-rabbitmq
          image: alpine
          command: ["sh", "-c", "for i in $(seq 1 300); do nc -zvw1 fredboat-rabbitmq-service 5672 && exit 0 || sleep 3; done; exit 1"]
      containers:
        - name: fredboat-sentinel
          image: fredboat/sentinel:dev
          imagePullPolicy: Always
          ports:
            - containerPort: 27212
          env:
            - name: SPRING_RABBITMQ_ADDRESSES
              value: amqp://guest:guest@fredboat-rabbitmq-service
          volumeMounts:
          - name: fredboat-configmap-volume
            mountPath: /opt/sentinel/common.yml
            subPath: common.yml
            readOnly: true
      volumes:
      - name: fredboat-configmap-volume
        configMap:
          name: fredboat-configmap
