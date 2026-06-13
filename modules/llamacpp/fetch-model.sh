log() {
  printf 'llm-fetch-models: %s\n' "$*"
}

fetch_model() {
  local model_id="$1"
  local target="$2"
  local etag_file="$3"
  local tmp_target="$4"
  local tmp_etag_file="$5"
  local url="$6"
  local http_status
  local -a curl_args

  log "checking model $model_id"
  rm -f "$tmp_target" "$tmp_etag_file"

  curl_args=(
    --location
    --silent
    --show-error
    --write-out '%{http_code}'
    --output "$tmp_target"
    --etag-save "$tmp_etag_file"
  )

  if [ -s "$target" ] && [ -s "$etag_file" ]; then
    log "checking remote ETag for $model_id"
    curl_args+=(--etag-compare "$etag_file")
  else
    log "model or ETag missing for $model_id; downloading"
  fi

  log "downloading/updating $model_id"
  if ! http_status="$("$CURL_BIN" "${curl_args[@]}" "$url")"; then
    log "error: curl failed while checking $model_id"
    rm -f "$tmp_target" "$tmp_etag_file"
    exit 1
  fi

  case "$http_status" in
    200)
      log "downloaded update for $model_id; validating"
      if [ ! -s "$tmp_target" ]; then
        log "error: downloaded file for $model_id is empty; keeping existing model"
        rm -f "$tmp_target" "$tmp_etag_file"
        exit 1
      fi
      if [ ! -s "$tmp_etag_file" ]; then
        log "error: no ETag returned for $model_id; keeping existing model"
        rm -f "$tmp_target" "$tmp_etag_file"
        exit 1
      fi
      mv -f "$tmp_target" "$target"
      mv -f "$tmp_etag_file" "$etag_file"
      log "saved model $target"
      log "saved ETag $etag_file"
      ;;
    304)
      log "already up to date: $model_id"
      rm -f "$tmp_target" "$tmp_etag_file"
      ;;
    404)
      log "error: not found for $model_id; check URL $url"
      rm -f "$tmp_target" "$tmp_etag_file"
      exit 1
      ;;
    *)
      log "error: unexpected HTTP status $http_status for $model_id"
      rm -f "$tmp_target" "$tmp_etag_file"
      exit 1
      ;;
  esac

  rm -f "$tmp_target" "$tmp_etag_file"
  if [ -s "$etag_file" ]; then
    log "ETag ready for $model_id"
  fi
}
