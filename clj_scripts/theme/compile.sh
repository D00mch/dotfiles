#! /bin/sh
mkdir -p META-INF/native-image

echo '[
  { 
    "name": "java.lang.reflect.AccessibleObject",
    "methods" : [{"name":"canAccess"}]
  }
  ]' | tee META-INF/native-image/logging.json

# add -H:+StaticExecutableWithDynamicLibC for linux buids
# -Djava.awt.headless=false needed for robot, https://github.com/oracle/graal/issues/3064

native-image -jar target/uberjar/theme-0.1.0-SNAPSHOT-standalone.jar \
    --initialize-at-build-time -H:Name=theme --no-fallback \
    -J-Dclojure.spec.skip.macros=true -J-Dclojure.compiler.direct-linking=true \
    --verbose --no-server -J-Xmx3G \
    --report-unsupported-elements-at-runtime --native-image-info \
    -Djava.awt.headless=false \
    -H:CCompilerOption=-pipe \
    -H:ReflectionConfigurationFiles=META-INF/native-image/logging.json \
    -H:+ReportExceptionStackTraces

chmod +x theme
