<!DOCTYPE html>
<html>
 %include('head.tpl')
    <body>
            %if user_autho == 1:
                % include('nav_students.tpl')
            %elif user_autho == 2:
                % include('nav_employers.tpl')
            %else:
                % include('nav.tpl')
            %end
            <main>
            <div class="main_jubo about">
                <div id="container_of_content">
                    <div class="container">
                        <h1>ABOUT</h1>
                        <h2 class="about_qw_intro"> We created Questway for the innovationsystem in southern Sweden.
                            For more people to use their skills and get in touch with each other.
                            There is no business model, everything is for free- we just love doing stuff!
                        </h2>
                    </div>
                </div>
            </div>
            <div id="qw_code">
                <h2>Entrepenures. Students. Awsome idéas!</h2>
                <code data-lang="python">
                    <table>
                        <tr>
                            <td class="gutter">
                                <pre class="lineno">1</pre>
                            </td>
                            <td><span class="purple">def</span> <span class="blue">create_magic</span>():</td>
                        </tr>
                        <tr>
                            <td class="gutter">
                                <pre class="lineno">2</pre>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;student = <span class="green">"awsome"</span></td>
                        </tr>
                        <tr>
                            <td class="gutter">
                                <pre class="lineno">3</pre>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;entrepenure = <span class="green">"idéa"</span></td>
                        </tr>
                        <tr>
                            <td class="gutter">
                                <pre class="lineno">4</pre>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;<span class="purple">while world</span>.status <span class="purple">not<span> <span class="green">"perfect"</span>:</td>
                        </tr>
                        <tr>
                            <td class="gutter">
                                <pre class="lineno">5</pre>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;magic = <span class="blue">connect(</span><span class="orange">student</span>, <span class="orange">entrepenure</span><span class="blue">)</span></td>
                        </tr>
                    </table>
                </code>
            </div>
            <div id="about_questway">
                <div class="container">
                    <h2>Finally, we made it easy to connect!</h2>
                    <div class="order">
                        <div class="num">1</div>
                        <h4>Entrepenure</h4>
                    </div>
                    <div class="bullet">
                        <div class="icon rocket"></div>
                        <p>Entrepenures who want to conect post a short desription of their idéa and what they need help with.</p>
                    </div>
                    <div class="order">
                        <div class="num">2</div>
                        <h4>Student</h4>
                    </div>
                    <div class="bullet">
                        <div class="icon letter"></div>
                        <p>Students apply for quests they want to be a part of, and submits a short desription of themselves.</p>
                    </div>
                    <div class="order">
                        <div class="num">3</div>
                        <h4>Magic</h4>
                    </div>
                    <div class="bullet">
                        <div class="icon bulb"></div>
                        <p>When a mach is doen, you get together and comes up with briliant idéas.</p>
                    </div>
                    <a href="/create_employer" class="btn red">JOIN US</a>
                </div>
            </div>
            <div class="qw_team">
                <div class="container">
                    <h2>The Questway Team</h2>
                    <div class="qw_team_profile">
                        <img src="/static/img/jacob.jpg">
                        <h3>JACOB PETTERSSON</h3>
                        <div class="bckgrd"><p>A true programmer who loves to fence!
                                Started the company The Working generation in 2013.
                                Is studying Information Architect at Malmö University.</p>
                        </div>
                        <p class="mail">jacob.pettersson@questway.se</p>
                    </div>
                    <div class="qw_team_profile">
                        <img src="/static/img/jari.jpg">
                        <h3>JARI ROSENSTRÖM</h3>
                        <div class="bckgrd"><p>A creative homechef that runs his own consulting company.
                                Is one of a kind when it comes to programming and is studying
                                Information Architect at Malmö University.</p>
                        </div>
                        <p class="mail">jari.rosenstrom@questway.se</p>
                    </div>
                    <div class="qw_team_profile">
                        <img src="/static/img/jenny.jpg">
                        <h3>JENNY SANDBERG</h3>
                        <div class="bckgrd"><p>A crazy-cat-lady, musical fan and a squash player who started working in
                                the local innovationsystem in 2013.
                                Currently working as a business developer at Drivhuset Malmö.</p>
                        </div>
                        <p class="mail">jenny.sandberg@questway.se</p>
                    </div>
                </div>
            </div>
            %include('footer.tpl')
        </main>
    </body>
</html>
