<div class="myPanel" id='myPanel'>
    <div class="myPanel__container">
        <div class="myPanel__header"> <input type="text" placeholder="请输入搜索内容" class="myPanel__header--input"> </div>
        <div class="myPanel__body">
            <ul class="myPanel__body--ul">
            </ul>
        </div>
    </div>
</div>


var vue = new Vue({
    el: '#myPanel',
    data: {
        items: [],
        value: '',
        show: false,
    },
    methods: {
        search: function () {

        },
        show: function () {
            this.show = true
        },
        hide: function () {
            this.show = false
        }
    },
    beforeMount: function () {
        // 保存引用
        var that = this
        // 请求数据
        $.ajax({
            url: "/search.json",
            dataType: 'json',
            success: function (data) {
                that.items = data
            },
            error: function(e, m){
               console.log('数据接口请求异常', e, m)
            }
        })
    }
})