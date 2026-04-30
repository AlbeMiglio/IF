#!/bin/zsh
JAVA17="/Users/albertomigliorato/Library/Java/JavaVirtualMachines/corretto-17.0.12/Contents/Home/bin/java"
JAVA21="/Users/albertomigliorato/Library/Java/JavaVirtualMachines/corretto-21.0.8/Contents/Home/bin/java"
JAVA25="/opt/homebrew/opt/openjdk/bin/java"
MAVEN_HOME="/Users/albertomigliorato/Applications/IntelliJ IDEA Ultimate.app/Contents/plugins/maven/lib/maven3"
MVN="$MAVEN_HOME/bin/mvn"

# ── Paper 1.16.5 via Paperclip ────────────────────────────────────────────────
mkdir -p paperclip
if [ ! -f paperclip/paper-1.16.5.jar ]; then
    wget "https://api.papermc.io/v2/projects/paper/versions/1.16.5/builds/794/downloads/paper-1.16.5-794.jar" -O paperclip/paper-1.16.5.jar
fi
if [ ! -f paperclip/cache/patched_1.16.5.jar ]; then
    cd paperclip
    $JAVA17 -jar paper-1.16.5.jar
    cd ..
fi
$MVN install:install-file \
    -Dfile=paperclip/cache/patched_1.16.5.jar \
    -DgroupId="io.papermc" \
    -DartifactId="paper" \
    -Dversion="1.16.5-R0.1-SNAPSHOT" \
    -Dpackaging="jar" \
    -DgeneratePom="true"

# ── BuildTools ─────────────────────────────────────────────────────────────────
mkdir -p build
cd build

if [ ! -f BuildTools.jar ]; then
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
fi

if [ ! -d Bukkit ]; then
    git clone https://hub.spigotmc.org/stash/scm/spigot/bukkit.git Bukkit
    git clone https://hub.spigotmc.org/stash/scm/spigot/craftbukkit.git CraftBukkit
    git clone https://hub.spigotmc.org/stash/scm/spigot/spigot.git Spigot
    git clone https://hub.spigotmc.org/stash/scm/spigot/builddata.git BuildData
fi

# ── Batch 1: 1.20.5 + 1.20.6 ──────────────────────────────────────────────────
cd Bukkit    && git fetch && git checkout 304e83eb384c338546aa96eea51388e0e8407e26 && cd ..
cd CraftBukkit && git fetch && git checkout 91b1fc3f1cf89e2591367dca1fa7362fe376f289 && cd ..
cd Spigot    && git fetch && git checkout b698b49caf14f97a717afd67e13fd7ac59f51089 && cd ..
cd BuildData && git fetch && git checkout a7f7c2118b877fde4cf0f32f1f730ffcdee8e9ee && cd ..

$JAVA21 -jar BuildTools.jar --remapped --disable-java-check --dont-update
$JAVA21 -jar BuildTools.jar --rev 1.20.6 --remapped --disable-java-check

# ── Batch 2: 1.21.1 – 1.21.11 ─────────────────────────────────────────────────
cd Bukkit    && git checkout 2ec53f498e32b3af989cb24672fc54dfab087154 && cd ..
cd CraftBukkit && git checkout 8ee6fd1b8db9896590aa321d0199453de1fc35db && cd ..
cd Spigot    && git checkout fb8fb722a327a2f9f097f2ded700ac5de8157408 && cd ..
cd BuildData && git checkout ae1e7b1e31cd3a3892bb05a6ccdcecc48c73c455 && cd ..

$JAVA21 -jar BuildTools.jar --remapped --disable-java-check --dont-update
$JAVA21 -jar BuildTools.jar --rev 1.21.1  --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.3  --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.4  --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.5  --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.8  --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.10 --remapped --disable-java-check
$JAVA21 -jar BuildTools.jar --rev 1.21.11 --remapped --disable-java-check

# ── 26.1.2 requires Java 25 ────────────────────────────────────────────────────
$JAVA25 -jar BuildTools.jar --rev 26.1.2 --remapped --disable-java-check

cd ..
echo "BuildTools done. Run: mvn install -DskipTests"
