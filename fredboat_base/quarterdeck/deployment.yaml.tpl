apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-quarterdeck
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-quarterdeck
  template:
    metadata:
      labels:
        app: fredboat-quarterdeck
    spec:
      initContainers:
        - name: init-wait-postgres
          image: alpine
          command: ["sh", "-c", "for i in $(seq 1 300); do nc -zvw1 fredboat-postgres-service {{ POSTGRES_PORT }} && exit 0 || sleep 3; done; exit 1"]
      containers:
        - name: fredboat-quarterdeck
          image: fredboat/quarterdeck:stable-v1
          imagePullPolicy: Always
          ports:
            - containerPort: {{ QUARTERDECK_PORT }}
          volumeMounts:
          - name: fredboat-configmap-volume
            mountPath: /opt/Quarterdeck/quarterdeck.yml
            subPath: quarterdeck.yml
            readOnly: true
      volumes:
      - name: fredboat-configmap-volume
        configMap:
          name: fredboat-configmap
