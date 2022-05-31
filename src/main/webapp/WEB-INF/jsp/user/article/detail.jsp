<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시글 상세" />
<%@ include file="../common/head.jspf"%>
<%@ include file="../../common/toastUiEditorLib.jspf"%>

<script>
	const params = {};
	params.id = parseInt('${param.id}');
</script>
<script>
	function ArticleDetail__increaseHitCount() {
		const localStorageKey = 'article__' + params.id + '__viewDone';
		if (localStorage.getItem(localStorageKey)) {
			return;
		}
		localStorage.setItem(localStorageKey, true);
		$.get('../article/doIncreaseHitCountRd', {
			id : params.id,
			ajaxMode : 'Y'
		}, function(data) {
			$('.article-detail__hit-count').empty().html(data.data1);
		}, 'json');
	}
	$(function() {
		ArticleDetail__increaseHitCount();
	})
</script>

<section>
  <div class="container mx-auto px-3">
    <div class="table-box-type-1">
      <table>

        <colgroup>
          <col width="200" />
        </colgroup>

        <tbody>
          <tr>
            <th>번호</th>
            <td>
              <div class="badge badge-primary">${ article.id }</div>
            </td>
          </tr>
          <tr>
            <th>작성날짜</th>
            <td>${ article.forPrintType2RegDate }</td>
          </tr>
          <tr>
            <th>수정날짜</th>
            <td>${ article.forPrintType2UpateDate }</td>
          </tr>
          <tr>
            <th>작성자</th>
            <td>${ article.extra__writerName }</td>
          </tr>
          <tr>
            <th>조회수</th>
            <td>
              <span class="badge badge-primary article-detail__hit-count">${ article.hitCount }</span>
            </td>
          </tr>
          <!-- 추천수 영역 시작 -->
          <tr>
            <th>추천수</th>
            <td>
              <div class="flex items-center">
                <span class="badge badge-primary">${ article.goodReactionPoint }</span>
                <span>&nbsp;</span>

                <c:if test="${ actorCanMakeReaction }">
                  <a
                    href="/user/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}"
                    class="btn btn-xs btn-secondary btn-outline">좋아요 👍</a>
                  <span>&nbsp;</span>
                  <a
                    href="/user/reactionPoint/doBadReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}"
                    class="btn btn-xs btn-accent btn-outline">싫어요 👎</a>
                </c:if>

                <c:if test="${ actorCanCancelGoodReaction }">
                  <a
                    href="/user/reactionPoint/doCancelGoodReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}"
                    class="btn btn-xs btn-secondary">좋아요 👍</a>
                  <span>&nbsp;</span>
                  <a href="#" title="먼저 좋아요를 취소해주세요." onclick="alert(this.title); return false;"
                    class="btn btn-xs btn-accent btn-outline">싫어요 👎</a>
                </c:if>

                <c:if test="${ actorCanCancelBadReaction }">
                  <a href="#" title="먼저 싫어요를 취소해주세요." onclick="alert(this.title); return false;"
                    class="btn btn-xs btn-secondary btn-outline">좋아요 👍</a>
                  <span>&nbsp;</span>
                  <a
                    href="/user/reactionPoint/doCancelBadReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}"
                    class="btn btn-xs btn-accent">싫어요 👎</a>
                </c:if>

              </div>
            </td>
          </tr>
          <!-- 추천수 영역 끝 -->
          <tr>
            <th>제목</th>
            <td>${ article.title }</td>
          </tr>
          <tr>
            <th>내용</th>
            <td>
              <div class="toast-ui-viewer">
                <script type="text/x-template">${article.body}</script>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 게시글 조작 영역 시작 -->
    <div class="btns mt-5">
      <button class="btn btn-secondary btn-outline mr-3" type="button" onclick="history.back();">뒤로가기</button>

      <c:if test="${ article.extra__actorCanModify }">
        <button class="btn btn-primary mr-3">
          <a href="../article/modify?id=${ article.id }">수정하기</a>
        </button>
      </c:if>

      <c:if test="${ article.extra__actorCanDelete }">
        <button class="btn btn-primary">
          <a href="../article/doDelete?id=${ article.id }"
            onclick="if( confirm('정말 삭제하시겠습니까?') == false ) return false;">삭제하기</a>
        </button>
      </c:if>
    </div>
    <!-- 게시글 조작 영역 끝 -->
  </div>
</section>

<!-- 댓글작성 관련 -->
<script>
	let ReplyWrite__submitFormDone = false;
	function ReplyWrite__submitForm(form) {
		if (ReplyWrite__submitFormDone) {
			return;
		}

		// 좌우공백 제거
		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}

		if (form.body.value.length < 2) {
			alert('댓글내용을 2자이상 입력해주세요.');
			form.body.focus();
			return;
		}

		ReplyWrite__submitFormDone = true;
		form.submit();
	}
</script>

<!-- 댓글 영역 시작 -->
<section class="mt-5">
  <div class="container mx-auto px-3">
    <c:if test="${ rq.logined }">
      <h1>댓글 작성</h1>
      <form class="table-box-type-1 mt-3" method="post" action="../reply/doWrite"
        onsubmit="ReplyWrite__submitForm(this); return false;">
        <input type="hidden" name="relTypeCode" value="article" />
        <input type="hidden" name="relId" value="${ article.id }" />
        <table>
          <colgroup>
            <col width="200" />
          </colgroup>

          <tbody>
            <tr>
              <th>작성자</th>
              <td>${ rq.loginedMember.nickname }</td>
            </tr>
            <tr>
              <th>내용</th>
              <td>
                <textarea class="w-full textarea textarea-bordered" name="body" rows="5" placeholder="내용을 입력해주세요."></textarea>
              </td>
            </tr>
          </tbody>
        </table>

        <div class="btns mt-5">
          <button class="btn btn-primary mr-3" type="submit">댓글 남기기</button>
        </div>
      </form>
    </c:if>
    <c:if test="${ rq.notLogined }">
      <h1>
        <a class="link link-primary" href="/user/member/login">로그인</a>
        후 댓글을 남길 수 있습니다.
      </h1>
    </c:if>
  </div>
</section>
<!-- 댓글 리스트 영역 -->
<section class="mt-5">
  <div class="container mx-auto px-3">
    <h1>댓글 목록 (${ replies.size() } 건)</h1>
    <table class="table table-fixed w-full">
      <colgroup>
        <col width="50" />
        <col width="100" />
        <col width="100" />
        <col width="50" />
        <col width="100" />
        <col width="150" />
        <col />
      </colgroup>
      <thead>
        <tr>
          <th>번호</th>
          <th>작성날짜</th>
          <th>수정날짜</th>
          <th>추천</th>
          <th>작성자</th>
          <th>비고</th>
          <th>내용</th>
        </tr>
      </thead>

      <tbody>
        <c:forEach var="reply" items="${ replies }">
          <tr>
            <th>${ reply.id }</th>
            <td>${ reply.forPrintType1RegDate }</td>
            <td>${ reply.forPrintType1UpdateDate }</td>
            <td>${ reply.goodReactionPoint }</td>
            <td>${ reply.extra__writerName }</td>
            <td>
              <!-- 댓글 조작 영역 시작 -->
              <div class="btns mt-5">
                <c:if test="${ reply.extra__actorCanModify }">
                  <a class="btn btn-link mr-3" href="../reply/modify?id=${ reply.id }">수정</a>
                </c:if>

                <c:if test="${ reply.extra__actorCanDelete }">
                  <a class="btn btn-link" href="../reply/doDelete?id=${ reply.id }"
                    onclick="if( confirm('정말 삭제하시겠습니까?') == false ) return false;">삭제</a>
                </c:if>
              </div>
              <!-- 댓글 조작 영역 끝 -->
            </td>
            <td>${ reply.forPrintBody }</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</section>
<!-- 댓글 영역 끝 -->
<%@ include file="../common/foot.jspf"%>