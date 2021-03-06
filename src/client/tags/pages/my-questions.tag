page-my-questions
    title 質問一覧 - マイページ - Quesdon
    loading(if="{!loaded}")
    virtual(if="{loaded}")
        h1 質問一覧
        a(href="/my") マイページへ
        my-question(each="{question in questions}",question="{question}")
        div: a.btn.btn-secondary.break-with-wbr.mt-3(href="https://{window.USER.hostName}/share?text={encodeURIComponent('私の'+window.USER.questionBoxName+'です #quesdon\n'+location.origin+'/@'+window.USER.acct)}",target="_blank")
            | 自分の質問箱のページを共有
            wbr
            | (新しいページで開きます)
    script.
        import "../loading.tag"
        apiFetch("/api/web/questions").then(r => r.json()).then(r => {
            this.questions = r
            this.loaded = true
            this.update()
        })
my-question
    form(action="javascript://",onsubmit="{submit}").mt-3
        .card
            .card-body
                h4.card-title {opts.question.question}
                p(if="{opts.question.questionUser}") 質問者:
                    a.ml-2(href="/@{opts.question.questionUser.acct}") {opts.question.questionUser.name}
                        span.text-muted  @{opts.question.questionUser.acct}
                textarea.form-control.mb-4(name="answer", placeholder="回答内容を入力", oninput="{input}")
                button.btn.btn-primary.card-link(type="submit",disabled="{answer_disabled}") 回答
                span.card-link 公開範囲: 
                    select.form-control.card-link(style="display:inline-block;width:inherit;",name="visibility")
                        option(value="public") 公開
                        option(value="unlisted") 未収載
                        option(value="private") 非公開
                        option(value="no") 投稿しない
                label.custom-control.custom-checkbox
                    input.custom-control-input(type="checkbox",name="isNSFW",value="1")
                    span.custom-control-indicator
                    span.custom-control-description NSFW
                button.btn.btn-danger(type="button",style="float:right;",onclick="{delete}") 削除
    script.
        this.answer_disabled = true
        this.input = e => {
            this.answer_disabled = !(e.target.value.length > 0)
            this.update()
        }
        this.submit = e => {
            var formData = new FormData(e.target)
            apiFetch("/api/web/questions/"+this.opts.question._id+"/answer", {
                method: "POST",
                body: formData
            }).then(r => r.json()).then(r => {
                alert("答えました")
                location.reload()
            })
        }
        this.delete = e => {
            if(!confirm("質問を削除します。\n削除した質問は二度と元に戻せません。\n本当に質問を削除しますか?")) return
            apiFetch("/api/web/questions/"+this.opts.question._id+"/delete", {
                method: "POST"
            }).then(r => r.json()).then(r => {
                alert("削除しました")
                location.reload()
            })
        }