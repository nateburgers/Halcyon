/**
 * @file mlp_async.cc
 */
#include <mlp_async.hh>

static
void signalHandler(int signal, siginfo_t *signalData, void *userData)
{
}

int main()
{
    timer_t           timerId;
    struct sigevent   signalEvent;
    struct itimerspec timerSpec;
    long long         nanoseconds;
    sigset_t          mask;
    struct sigaction  signalAction;

    signalAction.sa_flags = SA_SIGINFO;
    signalAction.sa_sigaction =

    return 0;
}
