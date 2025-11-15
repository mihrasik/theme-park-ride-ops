sudo apt update
sudo apt install -y openjdk-11-jdk

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ;;
  aarch64|arm64) export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64 ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac
export PATH=$JAVA_HOME/bin:$PATH

echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

./gradlew clean build